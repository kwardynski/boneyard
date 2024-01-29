defmodule IceBoxWeb.API.V1.CompanyController do
  use IceBoxWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias IceBox.Organization
  alias IceBox.Organization.Company

  alias OpenApiSpex.Schema

  alias IceBoxWeb.Schemas.Company.ListResponse
  alias IceBoxWeb.Schemas.Company.Request
  alias IceBoxWeb.Schemas.Company.Response

  action_fallback IceBoxWeb.FallbackController

  tags(["Companies"])

  operation :index,
    summary: "List Companies",
    responses: [
      ok: {"Companies", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    companies = Organization.list_companies()
    render(conn, :index, companies: companies)
  end

  operation :create,
    summary: "Create a Company",
    request_body: {"Company", "application/json", Request},
    responses: [
      ok: {"Companies", "application/json", Response}
    ]

  def create(conn, company_params) do
    with {:ok, %Company{} = company} <- Organization.create_company(company_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/company/#{company}")
      |> render(:show, company: company)
    end
  end

  operation :show,
    summary: "Show information for one Company",
    parameters: [
      id: [
        in: :path,
        schema: %Schema{type: :string, format: :uuid}
      ]
    ],
    responses: [
      ok: {"Companies", "application/json", Response}
    ]

  def show(conn, _params) do
    spec = IceBoxWeb.ApiSpec.spec()
    operation = open_api_operation(:show)
    {:ok, conn} = OpenApiSpex.cast_and_validate(spec, operation, conn, nil)

    company = Organization.get_company!(conn.params.id)
    render(conn, :show, company: company)
  end

  operation :update,
    summary: "Update a Company's information",
    parameters: [
      id: [
        in: :path,
        schema: %Schema{type: :string, format: :uuid}
      ]
    ],
    request_body: {"Company", "application/json", Request},
    responses: [
      ok: {"Companies", "application/json", Response}
    ]

  def update(conn, %{"id" => id} = params) do
    with(
      company <- Organization.get_company!(id),
      {:ok, %Company{} = company} <- Organization.update_company(company, params)
    ) do
      render(conn, :show, company: company)
    end
  end

  operation :delete,
    summary: "Delete a Company",
    parameters: [
      id: [
        in: :path,
        schema: %Schema{type: :string, format: :uuid}
      ]
    ],
    responses: [
      no_content: {"Companies", "application/json", Response}
    ]

  def delete(conn, %{"id" => id}) do
    company = Organization.get_company!(id)

    with {:ok, %Company{}} <- Organization.delete_company(company) do
      send_resp(conn, :no_content, "")
    end
  end
end
