defmodule PermissionDemoWeb.API.V1.UserController do
  use PermissionDemoWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PermissionDemo.Accounts
  alias PermissionDemo.Accounts.User

  alias OpenApiSpex.Schema
  alias PermissionDemoWeb.OpenApiSchemas.User.CreateRequest
  alias PermissionDemoWeb.OpenApiSchemas.User.ListResponse
  alias PermissionDemoWeb.OpenApiSchemas.User.Response

  action_fallback PermissionDemoWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Users"]

  operation :index,
    summary: "Show all Users",
    responses: [
      ok: {"Users", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  operation :create,
    summary: "Create a User",
    request_body: {"Users", "application/json", CreateRequest},
    responses: [
      ok: {"Users", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    user_params = Map.from_struct(body_params.user)

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/users/#{user}")
      |> render(:show, user: user)
    end
  end

  operation :show,
    summary: "Show a single User",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Users", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  operation :delete,
    summary: "Delete a single User",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Users", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
