defmodule PermissionDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PermissionDemoWeb.Telemetry,
      # Start the Ecto repository
      PermissionDemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PermissionDemo.PubSub},
      # Start Finch
      {Finch, name: PermissionDemo.Finch},
      # Start the Endpoint (http/https)
      PermissionDemoWeb.Endpoint
      # Start a worker by calling: PermissionDemo.Worker.start_link(arg)
      # {PermissionDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PermissionDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PermissionDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
