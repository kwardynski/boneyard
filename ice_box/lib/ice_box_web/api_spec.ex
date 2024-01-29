defmodule IceBoxWeb.ApiSpec do
  @moduledoc false
  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.Server

  @behaviour OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(IceBoxWeb.Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:ice_box, :description)),
        version: to_string(Application.spec(:ice_box, :vsn))
      },
      paths: Paths.from_router(IceBoxWeb.Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
