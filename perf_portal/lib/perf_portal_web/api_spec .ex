defmodule PerfPortalWeb.ApiSpec do
  @moduledoc false
  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.Server

  alias PerfPortalWeb.Endpoint
  alias PerfPortalWeb.Router

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:perf_portal, :description)),
        version: to_string(Application.spec(:perf_portal, :vsn))
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
