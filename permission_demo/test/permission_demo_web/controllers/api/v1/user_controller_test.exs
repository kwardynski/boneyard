defmodule PermissionDemoWeb.API.V1.UserControllerTest do
  use PermissionDemoWeb.ConnCase

  import PermissionDemo.AccountsFixtures
  import PermissionDemo.PermissionsFixtures

  alias OpenApiSpex.TestAssertions

  @api_spec PermissionDemoWeb.ApiSpec.spec()

  @create_attrs %{
    email: "some email",
    name: "some name"
  }
  @invalid_attrs %{email: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      %{"id" => id} =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/v1/users", user: @create_attrs)
        |> json_response(201)

      user =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> get(~p"/api/v1/users/#{id}")
        |> json_response(200)

      TestAssertions.assert_schema(user, "User Response", @api_spec)
      assert user["id"] == id
      assert user["name"] == Map.get(@create_attrs, :name)
      assert user["email"] == Map.get(@create_attrs, :email)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show user" do
    setup [:create_user]

    test "user is rendered with all granted permissions", %{conn: conn, user: user} do
      granted_permission_ids =
        for _ <- 1..3 do
          permission = permission_fixture(%{name: Ecto.UUID.generate()})
          grant_fixture(user.id, permission.id)
          permission.id
        end

      rendered_user =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> get(~p"/api/v1/users/#{user.id}")
        |> json_response(200)

      user_permissions = rendered_user["permissions"]

      TestAssertions.assert_schema(rendered_user, "User Response", @api_spec)
      assert rendered_user["id"] == user.id
      assert rendered_user["name"] == Map.get(@create_attrs, :name)
      assert rendered_user["email"] == Map.get(@create_attrs, :email)
      assert Enum.all?(user_permissions, &(&1["id"] in granted_permission_ids))
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/v1/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
