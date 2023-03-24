ExUnit.start()

Mox.defmock(Boruta.OauthMock, for: Boruta.OauthModule)
Mox.defmock(Boruta.OpenidMock, for: Boruta.OpenidModule)

Ecto.Adapters.SQL.Sandbox.mode(ExFleetYards.Repo, :manual)
