defmodule Wrazzle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WrazzleWeb.Telemetry,
      # Start the Ecto repository
      Wrazzle.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wrazzle.PubSub},
      # Start Finch
      {Finch, name: Wrazzle.Finch},
      # Start the Endpoint (http/https)
      WrazzleWeb.Endpoint
      # Start a worker by calling: Wrazzle.Worker.start_link(arg)
      # {Wrazzle.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wrazzle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WrazzleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
