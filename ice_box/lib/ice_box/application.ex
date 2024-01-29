defmodule IceBox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      IceBoxWeb.Telemetry,
      # Start the Ecto repository
      IceBox.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: IceBox.PubSub},
      # Start Finch
      {Finch, name: IceBox.Finch},
      # Start the Endpoint (http/https)
      IceBoxWeb.Endpoint
      # Start a worker by calling: IceBox.Worker.start_link(arg)
      # {IceBox.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IceBox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IceBoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
