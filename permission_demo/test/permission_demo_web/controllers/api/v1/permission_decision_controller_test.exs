defmodule PermissionDemoWeb.API.V1.PermissionDecisionControllerTest do
  use PermissionDemoWeb.ConnCase

  import PermissionDemo.AccountsFixtures
  import PermissionDemo.PermissionsFixtures

  alias OpenApiSpex.TestAssertions

  @api_spec PermissionDemoWeb.ApiSpec.spec()

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "user permissions are verified using the slow method", %{conn: conn} do
      # GIVEN a User with 3 granted Permissions
      user = user_fixture()

      for x <- 1..3 do
        permission = permission_fixture(%{name: "permission_#{x}"})
        grant_fixture(user.id, permission.id)
        permission.name
      end

      # WHEN checking if Permissions are granted
      request_body = %{
        user_id: user.id,
        permissions: ["permission_2", "permission_3", "permission_4"],
        method: "slow"
      }

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/v1/permission_decision", request_body)
        |> json_response(200)

      TestAssertions.assert_schema(response, "Permission Decision Response", @api_spec)

      # THEN only the granted Permissions are marked as TRUE
      expected_response = %{
        "permission_2" => true,
        "permission_3" => true,
        "permission_4" => false
      }

      assert response == expected_response
    end

    test "user permissions are verified using the fast method", %{conn: conn} do
      # GIVEN a User with 3 granted Permissions
      user = user_fixture()

      for x <- 1..3 do
        permission = permission_fixture(%{name: "permission_#{x}"})
        grant_fixture(user.id, permission.id)
        permission.name
      end

      # WHEN checking if Permissions are granted
      request_body = %{
        user_id: user.id,
        permissions: ["permission_2", "permission_3", "permission_4"],
        method: "fast"
      }

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/v1/permission_decision", request_body)
        |> json_response(200)

      TestAssertions.assert_schema(response, "Permission Decision Response", @api_spec)

      # THEN only the granted Permissions are marked as TRUE
      expected_response = %{
        "permission_2" => true,
        "permission_3" => true,
        "permission_4" => false
      }

      assert response == expected_response
    end
  end
end
