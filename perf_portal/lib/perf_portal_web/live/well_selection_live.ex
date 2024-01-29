defmodule PerfPortalWeb.WellSelectionLive do
  use PerfPortalWeb, :live_view

  alias PerfPortal.Assets
  alias PerfPortal.Completions

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        wells: Assets.list_wells(),
        selection: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Select a Well</h1>
    <div id="wells">
      <form phx-change="change" phx-submit="submit">
        <select name="well-id" phx-change="change">
          <option value=""></option>
          <%= for well <- @wells do %>
            <option value={well.id}><%= well.name %></option>
          <% end %>
        </select>
        <div>
          <button type="submit">
            GO
          </button>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("change", params, socket) do
    socket = assign(socket, selection: params["well-id"])
    {:noreply, socket}
  end

  def handle_event("submit", _params, socket) do
    socket.assigns.selection
    |> Assets.get_well!()
    |> Completions.get_perforations_for_plotting_by_well()

    case socket.assigns.selection do
      nil -> {:noreply, socket}
      well_id -> {:noreply, redirect(socket, to: "/well/#{well_id}/overview/")}
    end
  end
end
