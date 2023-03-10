defmodule ExFleetYardsApi.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  @moduledoc false

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children =
      [
        # Telemetry poller will execute the given period measurements
        # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
        {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
        # Add reporters as children of your supervision tree.
        # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      ] ++ instream_childs()

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc false
  def instream_childs do
    if ExFleetYardsApi.Telemetry.InstreamConnection.start_instream?() do
      [
        ExFleetYardsApi.Telemetry.InstreamConnection,
        {ExFleetYardsApi.Telemetry.InstreamBufferedWritter,
         [connection: ExFleetYardsApi.Telemetry.InstreamConnection]},
        {TelemetryMetricsTelegraf,
         metrics: metrics(), adapter: ExFleetYardsApi.Telemetry.InstreamBufferedWritter}
      ]
    else
      []
    end
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.api.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("ex_fleet_yards.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The sum of the other measurements"
      ),
      summary("ex_fleet_yards.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding the data received from the database"
      ),
      summary("ex_fleet_yards.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The time spent executing the query"
      ),
      summary("ex_fleet_yards.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "The time spent waiting for a database connection"
      ),
      summary("ex_fleet_yards.repo.query.idle_time",
        unit: {:native, :millisecond},
        description:
          "The time the connection spent waiting before being checked out for the query"
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {ExFleetYardsWeb, :count_users, []}
    ]
  end
end
