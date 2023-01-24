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

  def restart_timer(importer, force \\ false) do
    GenServer.cast(__MODULE__, {:timer, importer, force})
  end

  def imports_state() do
    GenServer.call(__MODULE__, :imports_state)
  end

  def imports_state(importer) do
    GenServer.call(__MODULE__, {:imports_state, importer})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_opts) do
    importers = importers()

    imports =
      importers
      |> Enum.map(&default_import_state_map(&1, enabled?()))
      |> Enum.into(%{})

    {:ok,
     %{
       importers: importers,
       imports: imports
     }}
  end

  @impl GenServer
  def handle_call(:imports_state, _from, state) do
    {:reply, state.imports, state}
  end

  @impl GenServer
  def handle_call({:imports_state, importer}, _from, state) do
    {:reply, Map.get(state.imports, importer, default_import_state(importer)), state}
  end

  @impl GenServer
  def handle_cast({:start, importer, force}, state) do
    {:noreply, state, {:continue, {:start, importer, force}}}
  end

  @impl GenServer
  def handle_cast({:timer, importer, force}, state) do
    {:noreply, state, {:continue, {:timer, importer, force}}}
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
  def handle_continue({:timer, importer, force}, %{imports: imports} = state) do
    importer_state =
      imports
      |> Map.get(importer, default_import_state(importer))

    :timer.cancel(importer_state.timer)

    importer_state =
      if importer_state.enable or force do
        Map.put(importer_state, :timer, start_timer(importer))
      else
        importer_state
      end

    imports = Map.put(imports, importer, importer_state)

    state =
      state
      |> Map.put(:imports, imports)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:start, importer, force}, state) do
    {:noreply, state, {:continue, {:start, importer, force}}}
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

        {:noreply, state, {:continue, {:timer, importer, false}}}
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

        {:noreply, state, {:continue, {:timer, importer, false}}}
    end
  end

  @impl GenServer
  def handle_info(msg, state) do
    Logger.warn("Unknown message #{inspect(msg)}")
    {:noreply, state}
  end

  # Private helpers
  defp default_import_state_map(importer, enable \\ false)

  defp default_import_state_map(importer, enable) when is_atom(importer),
    do: default_import_state_map({importer, []}, enable)

  defp default_import_state_map({importer, opts}, enable) do
    state = %{
      running: false,
      opts: opts,
      task: nil,
      timer: nil,
      enable: enable
    }

    state =
      if enable do
        Map.put(state, :timer, start_timer(importer))
      else
        state
      end

    {importer, state}
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

    :timer.cancel(import_state.timer)

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
    |> Map.put(:timer, nil)
  end

  defp start_importer_int(import_state, importer, false) do
    if import_state[:running] do
      import_state
    else
      start_importer_int(import_state, importer, true)
    end
  end

  @spec start_import_task(atom(), Keyword.t()) :: Task.t()
  defp start_import_task(importer, opts) do
    Task.Supervisor.async_nolink(@task_sup, importer, :import_data, [opts])
  end

  defp find_importer(importers, ref) when is_reference(ref) do
    importers
    |> Enum.find(fn
      {_importer, %{task: %{ref: task_ref}}} -> task_ref == ref
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

    import_state =
      import_state
      |> Map.put(:running, false)
      |> Map.put(:task, nil)
      |> Map.put(:import_info, nil)

    {importer, import_state}
  end

  defp start_timer(importer) do
    timer = ExFleetYardsImport.timer(importer)
    Process.send_after(self(), {:start, importer, false}, timer)
  end
end
