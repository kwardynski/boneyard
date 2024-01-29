defmodule PermissionDemoWeb.API.V1.GrantControllerTest do
  use PermissionDemoWeb.ConnCase

  import PermissionDemo.AccountsFixtures
  import PermissionDemo.PermissionsFixtures

  alias OpenApiSpex.TestAssertions

  @api_spec PermissionDemoWeb.ApiSpec.spec()

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all grants", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/grants")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create grant" do
    test "renders grant when data is valid", %{conn: conn} do
      %{id: user_id} = user_fixture()
      %{id: permission_id} = permission_fixture()
      create_attrs = %{user_id: user_id, permission_id: permission_id}

      %{"id" => grant_id} =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/v1/grants", grant: create_attrs)
        |> json_response(201)

      grant =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> get(~p"/api/v1/grants/#{grant_id}")
        |> json_response(200)

      TestAssertions.assert_schema(grant, "Grant Response", @api_spec)
      assert grant["id"] == grant_id
      assert grant["user_id"] == user_id
      assert grant["permission_id"] == permission_id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{user_id: :ok, permission_id: ["false"]}
      conn = post(conn, ~p"/api/v1/grants", grant: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete grant" do
    setup [:create_grant]

    test "deletes chosen grant", %{conn: conn, grant: grant} do
      conn = delete(conn, ~p"/api/v1/grants/#{grant}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/grants/#{grant}")
      end
    end
  end

  defp create_grant(_) do
    user = user_fixture()
    permission = permission_fixture()
    grant = grant_fixture(user.id, permission.id)

    %{grant: grant}
  end
end
