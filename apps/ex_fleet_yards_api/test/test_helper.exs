ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ExFleetYards.Repo, :manual)

Mox.defmock(ExFleetYardsApi.Plugs.AuthorizationMock, for: ExFleetYardsApi.Plugs.Authorization)
