defmodule PerfPortal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PerfPortalWeb.Telemetry,
      # Start the Ecto repository
      PerfPortal.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PerfPortal.PubSub},
      # Start Finch
      {Finch, name: PerfPortal.Finch},
      # Start the Endpoint (http/https)
      PerfPortalWeb.Endpoint
      # Start a worker by calling: PerfPortal.Worker.start_link(arg)
      # {PerfPortal.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PerfPortal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PerfPortalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
