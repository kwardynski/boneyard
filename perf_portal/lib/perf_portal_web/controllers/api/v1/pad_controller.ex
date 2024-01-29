defmodule PerfPortalWeb.API.V1.PadController do
  use PerfPortalWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias PerfPortal.Assets
  alias PerfPortal.Assets.Pad
  alias PerfPortal.Clients
  alias PerfPortal.Clients.Company

  alias OpenApiSpex.Schema
  alias PerfPortalWeb.Schemas.V1.Pad.CreateRequest
  alias PerfPortalWeb.Schemas.V1.Pad.ListResponse
  alias PerfPortalWeb.Schemas.V1.Pad.Response
  alias PerfPortalWeb.Schemas.V1.Pad.UpdateRequest

  action_fallback PerfPortalWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Assets"]

  operation :index,
    summary: "Show all Pads",
    response: [
      ok: {"Pads", "application/json", ListResponse}
    ]

  def index(conn, _params) do
    pads = Assets.list_pads()
    render(conn, :index, pads: pads)
  end

  operation :create,
    summary: "Create a Pad",
    request_body: {"Pads", "application/json", CreateRequest},
    responses: [
      ok: {"Pads", "application/json", Response}
    ]

  def create(%{body_params: body_params} = conn, _params) do
    pad_params = Map.from_struct(body_params.pad)

    with(
      %Company{} = company <- Clients.get_company!(pad_params.company_id),
      {:ok, %Pad{} = pad} <- Assets.create_pad(company, pad_params)
    ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/pads/#{pad}")
      |> render(:show, pad: pad)
    end
  end

  operation :show,
    summary: "Show a Pad",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      ok: {"Pads", "application/json", Response}
    ]

  def show(conn, %{id: id}) do
    pad = Assets.get_pad!(id)
    render(conn, :show, pad: pad)
  end

  operation :update,
    summary: "Update a Pad",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    request_body: {"Pads", "application/json", UpdateRequest},
    responses: [
      ok: {"Pads", "application/json", Response}
    ]

  def update(%{body_params: body_params} = conn, %{id: id}) do
    pad = Assets.get_pad!(id)
    pad_params = Map.from_struct(body_params.pad)

    with {:ok, %Pad{} = pad} <- Assets.update_pad(pad, pad_params) do
      render(conn, :show, pad: pad)
    end
  end

  operation :delete,
    summary: "Delete a Pad",
    parameters: [
      id: [in: :path, schema: %Schema{type: :string, format: :uuid}]
    ],
    responses: [
      no_content: {"Pads", "application/json", Response}
    ]

  def delete(conn, %{id: id}) do
    pad = Assets.get_pad!(id)

    with {:ok, %Pad{}} <- Assets.delete_pad(pad) do
      send_resp(conn, :no_content, "")
    end
  end
end
