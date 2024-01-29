defmodule PerfPortalWeb.API.V1.WellController do
  use PerfPortalWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PerfPortal.Assets
  alias PerfPortal.Assets.Pad
  alias PerfPortal.Assets.Well

  alias OpenApiSpex.Schema
  alias PerfPortalWeb.Schemas.V1.Well.CreateRequest
  alias PerfPortalWeb.Schemas.V1.Well.ListResponse
  alias PerfPortalWeb.Schemas.V1.Well.Response
  alias PerfPortalWeb.Schemas.V1.Well.UpdateRequest

  action_fallback PerfPortalWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Assets"]

  operation :index,
    summary: "Show all Wells",
    response: [
      ok: {"Wells", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    wells = Assets.list_wells()
    render(conn, :index, wells: wells)
  end

  operation :create,
    summary: "Create a Well",
    request_body: {"Wells", "application/json", CreateRequest},
    responses: [
      ok: {"Wells", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    well_params = Map.from_struct(body_params.well)

    with(
      %Pad{} = pad <- Assets.get_pad!(well_params.pad_id),
      {:ok, %Well{} = well} <- Assets.create_well(pad, well_params)
    ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/wells/#{well}")
      |> render(:show, well: well)
    end
  end

  operation :show,
    summary: "Show a Well",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Wells", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    well = Assets.get_well!(id)
    render(conn, :show, well: well)
  end

  operation :update,
    summary: "Update a Well",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    request_body: {"Wells", "application/json", UpdateRequest},
    responses: [
      ok: {"Wells", "application/json", Response}
    ]

  def update(%{body_params: body_params} = conn, %{id: id}) do
    well = Assets.get_well!(id)
    well_params = Map.from_struct(body_params.well)

    with {:ok, %Well{} = well} <- Assets.update_well(well, well_params) do
      render(conn, :show, well: well)
    end
  end

  operation :delete,
    summary: "Delete a Well",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Wells", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    well = Assets.get_well!(id)

    with {:ok, %Well{}} <- Assets.delete_well(well) do
      send_resp(conn, :no_content, "")
    end
  end
end
