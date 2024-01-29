defmodule PermissionDemoWeb.API.V1.GrantController do
  use PermissionDemoWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PermissionDemo.Permissions
  alias PermissionDemo.Permissions.Grant

  alias OpenApiSpex.Schema
  alias PermissionDemoWeb.OpenApiSchemas.Grant.CreateRequest
  alias PermissionDemoWeb.OpenApiSchemas.Grant.ListResponse
  alias PermissionDemoWeb.OpenApiSchemas.Grant.Response

  action_fallback PermissionDemoWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Grants"]

  operation :index,
    summary: "Show all Grants",
    responses: [
      ok: {"Grants", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    grants = Permissions.list_grants()
    render(conn, :index, grants: grants)
  end

  operation :create,
    summary: "Grant a Permission",
    request_body: {"Grants", "application/json", CreateRequest},
    responses: [
      ok: {"Grants", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    grant_params = Map.from_struct(body_params.grant)

    with {:ok, %Grant{} = grant} <- Permissions.create_grant(grant_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/grants/#{grant}")
      |> render(:show, grant: grant)
    end
  end

  operation :show,
    summary: "Show a Grant",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Grants", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    grant = Permissions.get_grant!(id)
    render(conn, :show, grant: grant)
  end

  operation :delete,
    summary: "Revoke a Permission",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Grants", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    grant = Permissions.get_grant!(id)

    with {:ok, %Grant{}} <- Permissions.delete_grant(grant) do
      send_resp(conn, :no_content, "")
    end
  end
end
