defmodule PerfPortalWeb.API.V1.PerforationController do
  use PerfPortalWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PerfPortal.Completions
  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Perforation

  alias OpenApiSpex.Schema
  alias PerfPortalWeb.Schemas.V1.Perforation.CreateRequest
  alias PerfPortalWeb.Schemas.V1.Perforation.ListResponse
  alias PerfPortalWeb.Schemas.V1.Perforation.Response
  alias PerfPortalWeb.Schemas.V1.Perforation.UpdateRequest

  action_fallback PerfPortalWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Completions"]

  operation :index,
    summary: "Show all Perforations",
    response: [
      ok: {"Perforations", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    perforations = Completions.list_perforations()
    render(conn, :index, perforations: perforations)
  end

  operation :create,
    summary: "Create a Perforation",
    request_body: {"Perforations", "application/json", CreateRequest},
    responses: [
      ok: {"Perforation", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    perforation_params = Map.from_struct(body_params.perforation)

    with(
      %Cluster{} = cluster <- Completions.get_cluster!(perforation_params.cluster_id),
      {:ok, %Perforation{} = perforation} <-
        Completions.create_perforation(cluster, perforation_params)
    ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/perforations/#{perforation}")
      |> render(:show, perforation: perforation)
    end
  end

  operation :show,
    summary: "Show a Perforation",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Perforations", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    perforation = Completions.get_perforation!(id)
    render(conn, :show, perforation: perforation)
  end

  operation :update,
    summary: "Update a Perforation",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    request_body: {"Perforations", "application/json", UpdateRequest},
    responses: [
      ok: {"Perforations", "application/json", Response}
    ]

  def update(%{body_params: body_params} = conn, %{id: id}) do
    perforation = Completions.get_perforation!(id)
    perforation_params = Map.from_struct(body_params.perforation)

    with {:ok, %Perforation{} = perforation} <-
           Completions.update_perforation(perforation, perforation_params) do
      render(conn, :show, perforation: perforation)
    end
  end

  operation :delete,
    summary: "Delete a Perforation",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Perforations", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    perforation = Completions.get_perforation!(id)

    with {:ok, %Perforation{}} <- Completions.delete_perforation(perforation) do
      send_resp(conn, :no_content, "")
    end
  end
end
