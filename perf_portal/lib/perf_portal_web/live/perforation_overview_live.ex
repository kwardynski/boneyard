defmodule PerfPortalWeb.PerforationOverviewLive do
  use PerfPortalWeb, :live_view

  alias PerfPortal.Completions

  def mount(params, _session, socket) do
    {:ok,
     assign(socket,
       charge_type: "Baker Hughes Predator XP",
       charge_link:
         "https://www.bakerhughes.com/evaluation/perforating/tubingconveyed-perforating/perforating-charges/predator-perforating-charges",
       perforation: Completions.get_perforation!(params["id"]),
       img_path: "/images/perf_#{Enum.random(1..3)}.png"
     )}
  end

  # def render(assigns) do
  #   ~H"""
  #   <img src={@img_path} alt="Italian Trulli">
  #   """
  # end

  def render(assigns) do
    ~H"""
    <h1>Perforation <%= @perforation.name %> Overview</h1>
    <div><img src={@img_path} class="center" /></div>
    <br />

    <div>
      <ul>Depth: <%= @perforation.depth %> m</ul>
      <ul>Phase: <%= @perforation.phase %> ° Clockwise from High Side</ul>
      <ul>Exit Diameter: <%= @perforation.exit_diameter %> in.</ul>
      <ul>Exit Diameter Increase: <%= @perforation.exit_diameter_increase %>%</ul>
    </div>
    <br />
    <a href={@charge_link}><%= @charge_type %></a>
    """
  end
end
