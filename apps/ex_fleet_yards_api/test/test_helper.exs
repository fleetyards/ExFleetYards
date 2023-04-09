ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ExFleetYards.Repo, :manual)

Mox.defmock(ExFleetYardsApi.Plugs.AuthorizationMock, for: ExFleetYardsApi.Plugs.Authorization)
Mox.defmock(Boruta.OauthMock, for: Boruta.OauthModule)
Mox.defmock(Boruta.OpenidMock, for: Boruta.OpenidModule)
