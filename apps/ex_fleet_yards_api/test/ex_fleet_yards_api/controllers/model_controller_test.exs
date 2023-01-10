defmodule ExFleetYardsApi.ModelControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Game Model Controller" do
    test "spec compliance (:show)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.model_path(conn, :show, "600i"))
        |> json_response(200)

      assert_schema json, "Model", api_spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.model_path(conn, :index))
        |> json_response(200)

      assert_schema json, "ModelList", api_spec
      assert json["data"] |> Enum.count() > 0
    end

    test "spec compliance (:loaners)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.model_path(conn, :loaners, "andromeda"))
        |> json_response(200)

      assert_schema hd(json), "Model", api_spec
      assert json |> Enum.count() > 0
    end

    test "spec compliance (:paints)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.model_path(conn, :paints, "stv"))
        |> json_response(200)

      assert_schema hd(json), "ModelPaint", api_spec
      assert json |> Enum.count() > 0
    end
  end
end
