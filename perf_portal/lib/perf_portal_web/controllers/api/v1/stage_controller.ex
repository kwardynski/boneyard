defmodule PerfPortalWeb.API.V1.StageController do
  use PerfPortalWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PerfPortal.Assets
  alias PerfPortal.Assets.Well
  alias PerfPortal.Completions
  alias PerfPortal.Completions.Stage

  alias OpenApiSpex.Schema
  alias PerfPortalWeb.Schemas.V1.Stage.CreateRequest
  alias PerfPortalWeb.Schemas.V1.Stage.ListResponse
  alias PerfPortalWeb.Schemas.V1.Stage.Response
  alias PerfPortalWeb.Schemas.V1.Stage.UpdateRequest

  action_fallback PerfPortalWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Completions"]

  operation :index,
    summary: "Show all Stages",
    response: [
      ok: {"Stages", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    stages = Completions.list_stages()
    render(conn, :index, stages: stages)
  end

  operation :create,
    summary: "Create a Stage",
    request_body: {"Stages", "application/json", CreateRequest},
    responses: [
      ok: {"Stages", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    stage_params = Map.from_struct(body_params.stage)

    with(
      %Well{} = well <- Assets.get_well!(stage_params.well_id),
      {:ok, %Stage{} = stage} <- Completions.create_stage(well, stage_params)
    ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/stages/#{stage}")
      |> render(:show, stage: stage)
    end
  end

  operation :show,
    summary: "Show a Stage",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Stages", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    stage = Completions.get_stage!(id)
    render(conn, :show, stage: stage)
  end

  operation :update,
    summary: "Update a Stage",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    request_body: {"Stages", "application/json", UpdateRequest},
    responses: [
      ok: {"Stages", "application/json", Response}
    ]

  def update(%{body_params: body_params} = conn, %{id: id}) do
    stage = Completions.get_stage!(id)
    stage_params = Map.from_struct(body_params.stage)

    with {:ok, %Stage{} = stage} <- Completions.update_stage(stage, stage_params) do
      render(conn, :show, stage: stage)
    end
  end

  operation :delete,
    summary: "Delete a Stage",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Stages", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    stage = Completions.get_stage!(id)

    with {:ok, %Stage{}} <- Completions.delete_stage(stage) do
      send_resp(conn, :no_content, "")
    end
  end
end
