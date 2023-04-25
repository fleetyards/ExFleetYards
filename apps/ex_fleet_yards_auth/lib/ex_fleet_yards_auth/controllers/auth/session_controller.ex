defmodule ExFleetYardsAuth.SessionController do
  use ExFleetYardsAuth, :controller

  alias ExFleetYardsAuth.Auth

  plug :put_view, html: ExFleetYardsAuth.SessionHTML

  def new(conn, params) do
    render(conn, "new.html", error: nil, email: params["login_hint"])
  end

  def create(conn, %{"sub" => sub, "otp_code" => code} = user_params) do
    user = ExFleetYards.Account.get!(ExFleetYards.Account.User, [id: sub], load: [:totp])

    user.totp
    |> ExFleetYards.Account.Totp.use(code, actor: user, verbose?: true)
    |> IO.inspect()
    |> case do
      {:ok, _} ->
        conn
        |> Auth.log_in_user(user, user_params)

      {:error, _} ->
        render(conn, "otp.html",
          error: "Invald code",
          sub: sub,
          remember_me: user_params["remember_me"]
        )
    end
  end

  def create(conn, user_params) do
    %{"email" => email, "password" => password} = user_params
    IO.inspect(user_params)

    ExFleetYards.Account.User
    |> Ash.Query.for_read(:login, %{username: email})
    |> Ash.Query.load(:totp)
    |> ExFleetYards.Account.read_one()
    |> case do
      {:ok, user} ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          if user.totp && user.totp.active do
            conn
            |> render("otp.html",
              error: nil,
              sub: user.id,
              remember_me: user_params["remember_me"]
            )
          else
            conn
            |> Auth.log_in_user(user, user_params)
          end
        else
          conn
          |> render("new.html", error: "Invalid email or password", email: email)
        end

      {:error, _} ->
        Bcrypt.no_user_verify()

        conn
        |> render("new.html", error: "Invalid email or password", email: email)
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.log_out_user()
    |> redirect(to: "/")
  end
end
