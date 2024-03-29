defmodule ExFleetYardsAuth.Controllers.Openid.AuthorizeControllerTest do
  use ExFleetYardsAuth.ConnCase, async: true
  import Plug.Conn
  import Phoenix.ConnTest

  import Mox

  alias Boruta.Oauth.AuthorizeResponse
  alias Boruta.Oauth.Error
  alias ExFleetYardsAuth.Openid.AuthorizeController

  setup :verify_on_exit!

  defmodule User do
    defstruct id: "1",
              email: "test@test.test",
              last_sign_in_at: nil,
              confirmed_at: NaiveDateTime.utc_now()
  end

  describe "authorize/2" do
    test "redirects_to login if prompt=login", %{conn: conn} do
      conn = %{conn | query_params: %{"prompt" => "login"}}

      assert_authorize_redirected_to_login(conn)
    end

    test "redirects_to login if user is invalid", %{conn: conn} do
      current_user = %User{}
      conn = assign(conn, :current_user, current_user)

      error = %Error{
        status: :unauthorized,
        error: :invalid_resource_owner,
        error_description: "Error description",
        format: :query
      }

      Boruta.OauthMock
      |> expect(:preauthorize, fn conn, _resource_owner, module ->
        module.preauthorize_error(conn, error)
      end)

      assert_authorize_redirected_to_login(conn)
    end

    test "redirects_to an error if prompt=none and user not logged in", %{conn: conn} do
      conn = %{conn | query_params: %{"prompt" => "none"}}

      error = %Error{
        status: :unauthorized,
        error: :login_required,
        error_description: "Error description",
        format: :fragment
      }

      Boruta.OauthMock
      |> expect(:preauthorize, fn conn, _resource_owner, module ->
        module.preauthorize_error(conn, error)
      end)

      conn =
        conn
        |> get("/openid/authorize", %{"prompt" => "none"})

      assert redirected_to(conn) =~ ~r/error=login_required/
    end

    test "redirects to login if user is logged in and max age is expired", %{conn: conn} do
      current_user = %User{last_sign_in_at: DateTime.utc_now()}
      conn = assign(conn, :current_user, current_user)

      assert_authorize_user_logged_out(conn, %{"max_age" => "0"})
    end

    test "authorizes if user is logged in and max age is not expired", %{conn: conn} do
      # FIXME: Fix this test
      # current_user = %User{last_sign_in_at: DateTime.utc_now()}
      # conn = assign(conn, :current_user, current_user)

      # response = %AuthorizeResponse{
      #   type: :token,
      #   redirect_uri: "http://redirect.uri",
      #   access_token: "access_token",
      #   expires_in: 10
      # }

      # Boruta.OauthMock
      # |> expect(:preauthorize, fn conn, _resource_owner, module ->
      #   module.preauthorize_success(conn, response)
      # end)

      # conn =
      #   conn
      #   |> get("/openid/authorize", %{"max_age" => "10"})

      # assert redirected_to(conn) ==
      #          "http://redirect.uri#access_token=access_token&expires_in=10"
    end

    test "redirects to user login when user not logged in", %{conn: conn} do
      assert_authorize_redirected_to_login(conn)
    end

    test "returns an error page", %{conn: conn} do
      current_user = %User{}
      conn = assign(conn, :current_user, current_user)

      error = %Error{
        status: :bad_request,
        error: :unknown_error,
        error_description: "Error description"
      }

      Boruta.OauthMock
      |> expect(:preauthorize, fn conn, _resource_owner, module ->
        module.preauthorize_error(conn, error)
      end)

      conn =
        conn
        |> get("/openid/authorize", %{})

      assert html_response(conn, 400) =~ ~r/Error description/
    end

    test "returns an error in fragment", %{conn: conn} do
      current_user = %User{}
      conn = assign(conn, :current_user, current_user)

      error = %Error{
        status: :bad_request,
        error: :unknown_error,
        error_description: "Error description",
        format: :fragment,
        redirect_uri: "http://redirect.uri"
      }

      Boruta.OauthMock
      |> expect(:preauthorize, fn conn, _resource_owner, module ->
        module.preauthorize_error(conn, error)
      end)

      conn =
        conn
        |> get("/openid/authorize", %{})

      assert redirected_to(conn) ==
               "http://redirect.uri#error=unknown_error&error_description=Error+description"
    end

    test "returns an error in query", %{conn: conn} do
      current_user = %User{}
      conn = assign(conn, :current_user, current_user)

      error = %Error{
        status: :bad_request,
        error: :unknown_error,
        error_description: "Error description",
        format: :query,
        redirect_uri: "http://redirect.uri"
      }

      Boruta.OauthMock
      |> expect(:preauthorize, fn conn, _resource_owner, module ->
        module.preauthorize_error(conn, error)
      end)

      conn =
        conn
        |> get("/openid/authorize", %{})

      assert redirected_to(conn) ==
               "http://redirect.uri?error=unknown_error&error_description=Error+description"
    end
  end

  defp assert_authorize_redirected_to_login(conn, query \\ %{}) do
    conn =
      conn
      |> get("/openid/authorize", query)

    assert redirected_to(conn, 302) == "/login"
  end

  defp assert_authorize_user_logged_out(conn, query \\ %{}) do
    # FIXME: fix test
    # conn =
    #   conn
    #   |> get("/openid/authorize", query)

    # assert redirected_to(conn, 302) == "/login"
    # assert get_session(conn, :user_return_to) == "/openid/authorize"
  end
end
