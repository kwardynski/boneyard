defmodule PermissionDemoWeb.API.V1.PermissionControllerTest do
  use PermissionDemoWeb.ConnCase

  import PermissionDemo.PermissionsFixtures

  alias OpenApiSpex.TestAssertions

  @api_spec PermissionDemoWeb.ApiSpec.spec()

  @create_attrs %{
    name: "some name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all permissions", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/permissions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create permission" do
    test "renders permission when data is valid", %{conn: conn} do
      %{"id" => id} =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/v1/permissions", permission: @create_attrs)
        |> json_response(201)

      permission =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> get(~p"/api/v1/permissions/#{id}")
        |> json_response(200)

      TestAssertions.assert_schema(permission, "Permission Response", @api_spec)
      assert permission["id"] == id
      assert permission["name"] == Map.get(@create_attrs, :name)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/permissions", permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete permission" do
    setup [:create_permission]

    test "deletes chosen permission", %{conn: conn, permission: permission} do
      conn = delete(conn, ~p"/api/v1/permissions/#{permission}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/permissions/#{permission}")
      end
    end
  end

  defp create_permission(_) do
    permission = permission_fixture()
    %{permission: permission}
  end
end
