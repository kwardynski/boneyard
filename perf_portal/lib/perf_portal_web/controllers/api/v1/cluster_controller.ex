defmodule PerfPortalWeb.API.V1.ClusterController do
  use PerfPortalWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PerfPortal.Completions
  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Stage

  alias OpenApiSpex.Schema
  alias PerfPortalWeb.Schemas.V1.Cluster.CreateRequest
  alias PerfPortalWeb.Schemas.V1.Cluster.ListResponse
  alias PerfPortalWeb.Schemas.V1.Cluster.Response
  alias PerfPortalWeb.Schemas.V1.Cluster.UpdateRequest

  action_fallback PerfPortalWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Completions"]

  operation :index,
    summary: "Show all Clusters",
    response: [
      ok: {"Clusters", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    clusters = Completions.list_clusters()
    render(conn, :index, clusters: clusters)
  end

  operation :create,
    summary: "Create a Cluster",
    request_body: {"Clusters", "application/json", CreateRequest},
    responses: [
      ok: {"Cluster", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    cluster_params = Map.from_struct(body_params.cluster)

    with(
      %Stage{} = stage <- Completions.get_stage!(cluster_params.stage_id),
      {:ok, %Cluster{} = cluster} <- Completions.create_cluster(stage, cluster_params)
    ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/clusters/#{cluster}")
      |> render(:show, cluster: cluster)
    end
  end

  operation :show,
    summary: "Show a Cluster ",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Clusters", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    cluster = Completions.get_cluster!(id)
    render(conn, :show, cluster: cluster)
  end

  operation :update,
    summary: "Update a Cluster",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    request_body: {"Clusters", "application/json", UpdateRequest},
    responses: [
      ok: {"Clusters", "application/json", Response}
    ]

  def update(%{body_params: body_params} = conn, %{id: id}) do
    cluster = Completions.get_cluster!(id)
    cluster_params = Map.from_struct(body_params.cluster)

    with {:ok, %Cluster{} = cluster} <- Completions.update_cluster(cluster, cluster_params) do
      render(conn, :show, cluster: cluster)
    end
  end

  operation :delete,
    summary: "Delete a Cluster",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Clusters", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    cluster = Completions.get_cluster!(id)

    with {:ok, %Cluster{}} <- Completions.delete_cluster(cluster) do
      send_resp(conn, :no_content, "")
    end
  end
end
