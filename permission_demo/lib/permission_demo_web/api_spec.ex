defmodule PermissionDemoWeb.ApiSpec do
  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.Server

  alias PermissionDemoWeb.Endpoint
  alias PermissionDemoWeb.Router

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [Server.from_endpoint(Endpoint)],
      info: %Info{
        title: to_string(Application.spec(:permission_demo, :description)),
        version: to_string(Application.spec(:permission_demo, :vsn))
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
