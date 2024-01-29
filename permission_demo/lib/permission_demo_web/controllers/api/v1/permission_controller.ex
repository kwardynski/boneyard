defmodule PermissionDemoWeb.API.V1.PermissionController do
  use PermissionDemoWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PermissionDemo.Permissions
  alias PermissionDemo.Permissions.Permission

  alias OpenApiSpex.Schema
  alias PermissionDemoWeb.OpenApiSchemas.Permission.CreateRequest
  alias PermissionDemoWeb.OpenApiSchemas.Permission.ListResponse
  alias PermissionDemoWeb.OpenApiSchemas.Permission.Response

  action_fallback PermissionDemoWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Permissions"]

  operation :index,
    summary: "Show all Permissions",
    responses: [
      ok: {"Permissions", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    permissions = Permissions.list_permissions()
    render(conn, :index, permissions: permissions)
  end

  operation :create,
    summary: "Create a Permission",
    request_body: {"Permissions", "application/json", CreateRequest},
    responses: [
      ok: {"Permissions", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    permission_params = Map.from_struct(body_params.permission)

    with {:ok, %Permission{} = permission} <- Permissions.create_permission(permission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/permissions/#{permission}")
      |> render(:show, permission: permission)
    end
  end

  operation :show,
    summary: "Show a single Permission",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Permissions", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    permission = Permissions.get_permission!(id)
    render(conn, :show, permission: permission)
  end

  operation :delete,
    summary: "Delete a single Permission",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Users", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{}} <- Permissions.delete_permission(permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
