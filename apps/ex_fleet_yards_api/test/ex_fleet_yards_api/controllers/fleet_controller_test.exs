defmodule ExFleetYardsApi.FleetControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Fleet

  describe "Fleet Controller" do
    # test "create, update, get and delete", %{conn: conn, auth_conn: auth_conn, api_spec: spec} do
    #  json =
    #    auth_conn
    #    |> post(Routes.fleet_path(auth_conn, :create), %{
    #      "name" => "Test Fleet",
    #      "fid" => "test-fleet",
    #      "description" => "Test Fleet Description",
    #      "publicFleet" => true
    #    })
    #    |> json_response(201)

    #  assert_schema json, "Fleet", spec
    #  assert json["slug"] == "test-fleet"
    #  assert json["fid"] == "test-fleet"
    #  assert json["publicFleet"] == true

    #  user = Account.get_user_by_username("testuser")
    #  fleet = Fleet.get("test-fleet")
    #  assert Fleet.has_role?(fleet, user, :admin)
    #  assert Fleet.has_role?(fleet, user, :officer)
    #  assert Fleet.has_role?(fleet, user, :member)

    #  assert_get(auth_conn, true, spec)
    #  assert_get(conn, nil, spec)

    #  json =
    #    auth_conn
    #    |> patch(Routes.fleet_path(auth_conn, :update, "test-fleet"), %{"publicFleet" => false})
    #    |> json_response(200)

    #  assert_schema json, "Fleet", spec
    #  assert json["slug"] == "test-fleet"
    #  assert json["fid"] == "test-fleet"
    #  assert json["publicFleet"] == false

    #  assert_error_sent 401, fn ->
    #    assert_get(conn, nil, spec)
    #  end

    #  assert_get(auth_conn, false, spec)

    #  json =
    #    auth_conn
    #    |> delete(Routes.fleet_path(auth_conn, :delete, "test-fleet"))
    #    |> json_response(200)

    #  assert_schema json, "Error", spec
    #  assert json["code"] == "success"

    #  assert_error_sent 404, fn ->
    #    assert_get(auth_conn, nil, spec)
    #  end
    # end
  end

  defp assert_get(conn, public, spec) do
    json =
      conn
      |> get(Routes.fleet_path(conn, :get, "test-fleet"))
      |> json_response(200)

    assert_schema json, "Fleet", spec
    assert json["slug"] == "test-fleet"
    assert json["fid"] == "test-fleet"

    if public == nil do
      assert is_nil(json["publicFleet"])
    else
      assert json["publicFleet"] == public
    end
  end
end
