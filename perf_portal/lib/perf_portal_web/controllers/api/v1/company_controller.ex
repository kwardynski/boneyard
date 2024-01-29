defmodule PerfPortalWeb.API.V1.CompanyController do
  use PerfPortalWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PerfPortal.Clients
  alias PerfPortal.Clients.Company

  alias OpenApiSpex.Schema
  alias PerfPortalWeb.Schemas.V1.Company.CreateRequest
  alias PerfPortalWeb.Schemas.V1.Company.ListResponse
  alias PerfPortalWeb.Schemas.V1.Company.Response
  alias PerfPortalWeb.Schemas.V1.Company.UpdateRequest

  action_fallback PerfPortalWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Companies"]

  operation :index,
    summary: "Show all Companies",
    response: [
      ok: {"Companies", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    companies = Clients.list_companies()
    render(conn, :index, companies: companies)
  end

  operation :create,
    summary: "Create a Company",
    request_body: {"Companies", "application/json", CreateRequest},
    responses: [
      ok: {"Companies", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    company_params = Map.from_struct(body_params.company)

    with {:ok, %Company{} = company} <- Clients.create_company(company_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/companies/#{company}")
      |> render(:show, company: company)
    end
  end

  operation :show,
    summary: "Show a Company",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Companies", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    company = Clients.get_company!(id)
    render(conn, :show, company: company)
  end

  operation :update,
    summary: "Update a Company",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    request_body: {"Companies", "application/json", UpdateRequest},
    responses: [
      ok: {"Companies", "application/json", Response}
    ]

  def update(%{body_params: body_params} = conn, %{id: id}) do
    company = Clients.get_company!(id)
    company_params = Map.from_struct(body_params.company)

    with {:ok, %Company{} = company} <- Clients.update_company(company, company_params) do
      render(conn, :show, company: company)
    end
  end

  operation :delete,
    summary: "Delete a Company",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Companies", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    company = Clients.get_company!(id)

    with {:ok, %Company{}} <- Clients.delete_company(company) do
      send_resp(conn, :no_content, "")
    end
  end
end
