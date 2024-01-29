defmodule PerfPortalWeb.ClusterComparisonLive do
  # https://fly.io/phoenix-files/liveview-multi-select/
  use PerfPortalWeb, :live_view

  alias PerfPortal.Analytics.PerforationAnalytics
  alias PerfPortal.Completions

  defp blue, do: "#0000FF"
  defp red, do: "#FF0000"

  def mount(params, _session, socket) do
    clusters = Completions.get_clusters_for_comparison_by_well_id(params["id"])

    {:ok,
     assign(socket,
       clusters: clusters,
       cluster_1: nil,
       cluster_2: nil,
       perforations: []
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Clusters</h1>
    <div id="clusters">
      <div id="cluster-comparison" phx-hook="ClusterComparison">
        <form phx-change="change" phx-submit="submit">
          <select name="cluster-1" phx-change="change">
            <option value=""></option>
            <%= for cluster <- @clusters do %>
              <option value={cluster.id}><%= cluster.name %></option>
            <% end %>
          </select>
          <select name="cluster-2" phx-change="change">
            <option value=""></option>
            <%= for cluster <- @clusters do %>
              <option value={cluster.id}><%= cluster.name %></option>
            <% end %>
          </select>
          <div>
            <button type="submit">
              GO
            </button>
          </div>
        </form>
      </div>
      <br />
      <div phx-update="ignore" id="cluster-comparison-chart-wrapper">
        <div id="cluster-comparison-chart"></div>
      </div>
    </div>
    """
  end

  def handle_event("change", %{"cluster-1" => cluster_id}, socket) do
    {:noreply, assign(socket, cluster_1: sanitize_id(cluster_id))}
  end

  def handle_event("change", %{"cluster-2" => cluster_id}, socket) do
    {:noreply, assign(socket, cluster_2: sanitize_id(cluster_id))}
  end

  def handle_event("submit", _params, socket) do
    cluster_1_id = socket.assigns.cluster_1
    cluster_2_id = socket.assigns.cluster_2
    cluster_ids = [cluster_1_id, cluster_2_id]

    cond do
      Enum.any?(cluster_ids, &is_nil/1) ->
        IO.puts("at least one nil")
        {:noreply, push_event(socket, "at-least-one-nil", %{})}

      cluster_1_id == cluster_2_id ->
        IO.puts("same cluster selected")
        {:noreply, push_event(socket, "same-cluster-selected", %{})}

      true ->
        perforations =
          cluster_ids
          |> Completions.get_perforations_for_plotting_by_cluster_ids()
          |> PerforationAnalytics.normalize_depths()
          |> add_colors()

        max_depth = PerforationAnalytics.max_depth(perforations)
        legend_values = generate_legend_values(perforations, max_depth)

        socket =
          socket
          |> push_event("plot-perforations", %{
            perforations: perforations,
            max_depth: max_depth,
            legend_values: legend_values
          })

        {:noreply, socket}
    end
  end

  defp sanitize_id(""), do: nil
  defp sanitize_id(id), do: id

  defp add_colors(perforations) do
    [cluster_1, _] =
      perforations
      |> Enum.map(& &1.cluster_name)
      |> Enum.uniq()

    Enum.map(perforations, fn perforation ->
      color =
        if perforation.cluster_name == cluster_1,
          do: blue(),
          else: red()

      Map.put(perforation, :color, color)
    end)
  end

  defp generate_legend_values(perforations, max_depth) do
    [cluster_1, cluster_2] =
      perforations
      |> Enum.map(& &1.cluster_name)
      |> Enum.uniq()

    [
      %{
        text: cluster_1,
        color: blue(),
        depth: 0,
        phase: 370
      },
      %{
        text: cluster_2,
        color: red(),
        depth: max_depth / 20,
        phase: 370
      }
    ]
  end
end
