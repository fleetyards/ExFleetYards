defmodule ExFleetYardsImport.Scheduler do
  @moduledoc false
  use GenServer
  require Logger
  alias ExFleetYards.Repo.Import, as: DBImport

  @app :ex_fleet_yards_import
  @task_sup ExFleetYardsImport.ImportTaskSupervisor

  @doc """
  Returns if automatic importing is enabled
  """
  @spec enabled?() :: boolean()
  def enabled?(), do: ExFleetYards.Config.get(@app, :enabled, true)

  @doc """
  Returns the configured importers.
  """
  @spec importers() :: list(atom())
  def importers, do: ExFleetYards.Config.get(@app, :importers, [])

  @doc """
  Start an importer
  """
  def start_importer(importer, force \\ false) do
    GenServer.cast(__MODULE__, {:start, importer, force})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_opts) do
    importers = importers()

    imports = %{}

    {:ok,
     %{
       importers: importers,
       imports: imports
     }}
  end

  @impl GenServer
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_cast({:start, importer, force}, state) do
    {:noreply, state, {:continue, {:start, importer, force}}}
  end

  @impl GenServer
  def handle_continue({:start, importer, force}, %{imports: imports} = state) do
    importer_state =
      imports
      |> Map.get(importer, default_import_state(importer))
      |> start_importer_int(importer, force)

    imports = Map.put(imports, importer, importer_state)

    state =
      state
      |> Map.put(:imports, imports)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({ref, result}, %{imports: imports} = state) do
    find_importer(imports, ref)
    |> finish_importer(result)
    |> case do
      nil ->
        Logger.warn("Unknown import task #{inspect(ref)} finished")
        {:noreply, state}

      {importer, importer_state} ->
        state =
          state
          |> Map.put(:imports, Map.put(imports, importer, importer_state))

        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(
        {:DOWN, ref, :process, _pid, {exception, stacktrace}},
        %{imports: imports} = state
      )
      when is_exception(exception) and is_list(stacktrace) do
    message = Exception.format(:exit, exception, stacktrace)

    find_importer(imports, ref)
    |> finish_importer({:error, message})
    |> case do
      nil ->
        Logger.warn("Unknown import task #{inspect(ref)} finished")
        {:noreply, state}

      {importer, importer_state} ->
        state =
          state
          |> Map.put(:imports, Map.put(imports, importer, importer_state))

        {:noreply, state}
    end
  end

  # TODO: remove
  @impl GenServer
  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end

  # Private helpers
  defp default_import_state_map(importer) when is_atom(importer),
    do: default_import_state_map({importer, []})

  defp default_import_state_map({importer, opts}) do
    {importer,
     %{
       running: false,
       opts: opts,
       task: nil
     }}
  end

  defp default_import_state(importer) when is_atom(importer) do
    {_, state} = default_import_state_map({importer, []})
    state
  end

  defp start_importer_int(import_state, import, true) do
    Logger.debug("#{import}: Starting")
    # Stop old task
    if import_state.task do
      Task.shutdown(import_state.task, 200)
    end

    import_info =
      create_import_info(import)
      |> case do
        {:ok, info} ->
          info

        {:error, reason} ->
          Logger.error("#{import}: Failed to create import info: #{inspect(reason)}")
          nil
      end

    task = start_import_task(import, import_state.opts)

    import_state
    |> Map.put(:running, true)
    |> Map.put(:task, task)
    |> Map.put(:import_info, import_info)
  end

  defp start_importer_int(import_state, importer, false) do
    if !import_state[:running] do
      start_importer_int(import_state, importer, true)
    else
      import_state
    end
  end

  @spec start_import_task(atom(), Keyword.t()) :: Task.t()
  defp start_import_task(importer, opts) do
    Task.Supervisor.async_nolink(@task_sup, importer, :import_data, opts)
  end

  defp find_importer(importers, ref) when is_reference(ref) do
    importers
    |> Enum.find(fn
      {_importer, %{task: %{ref: ref}}} -> ref == ref
      _ -> false
    end)
  end

  defp create_import_info(importer) do
    DBImport.create(
      importer.data_source(),
      importer.data_name()
    )
  end

  defp finish_importer(nil, _result), do: nil

  defp finish_importer({importer, import_state}, result) do
    {failed, params} =
      case result do
        {:error, v} ->
          Logger.error("#{importer.name()}: failed: #{v}")
          {true, %{info: to_string(v)}}

        {:ok, v} ->
          Logger.debug("#{importer.name()}: success: #{v}")
          {false, %{version: v}}

        _ ->
          Logger.warn("#{importer.name()}: unknown result: #{inspect(result)}")
          {true, %{info: inspect(result)}}
      end

    if import_state.import_info do
      DBImport.update(import_state.import_info, failed, params)
    end

    import_state
    |> Map.put(:running, false)
    |> Map.put(:task, nil)
    |> Map.put(:import_info, nil)

    {importer, import_state}
  end
end
