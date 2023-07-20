ExUnit.start()

Mox.defmock(Boruta.OauthMock, for: Boruta.OauthModule)
Mox.defmock(Boruta.OpenidMock, for: Boruta.OpenidModule)
Mox.defmock(ExFleetYards.Plugs.ApiAuthorizationMock, for: ExFleetYards.Plugs.ApiAuthorization)

Ecto.Adapters.SQL.Sandbox.mode(ExFleetYards.Repo, :manual)
