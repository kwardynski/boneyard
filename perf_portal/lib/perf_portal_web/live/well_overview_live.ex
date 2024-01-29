defmodule PerfPortalWeb.WellOverviewLive do
  use PerfPortalWeb, :live_view

  alias PerfPortal.Assets
  alias PerfPortal.Completions

  alias PerfPortal.Analytics.PerforationAnalytics

  def mount(params, _session, socket) do
    well = Assets.get_well!(params["id"])
    perforations = Completions.get_perforations_for_plotting_by_well(well)

    {:ok,
     assign(socket,
       well: well,
       perforations: perforations,
       plugs: [],
       statistics: %{}
     )}
  end

  def handle_event("fetch-plotting-data", _, socket) do
    {
      :reply,
      %{
        perforations: socket.assigns.perforations,
        max_depth: PerforationAnalytics.max_depth(socket.assigns.perforations),
        min_depth: PerforationAnalytics.min_depth(socket.assigns.perforations)
      },
      socket
    }
  end

  def handle_event("reset-zoom", _, socket) do
    {:noreply, push_event(socket, "reset-zoom", %{})}
  end
end
