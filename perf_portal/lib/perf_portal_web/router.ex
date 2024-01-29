defmodule PerfPortalWeb.Router do
  use PerfPortalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PerfPortalWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: PerfPortalWeb.ApiSpec
  end

  scope "/" do
    pipe_through :browser
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"

    live "/perforation/:id/overview", PerfPortalWeb.PerforationOverviewLive

    live "/well_selection", PerfPortalWeb.WellSelectionLive
    live "/well/:id/overview", PerfPortalWeb.WellOverviewLive
    live "/well/:id/cluster_comparison", PerfPortalWeb.ClusterComparisonLive
  end

  scope "/api" do
    pipe_through :api

    scope "/v1", PerfPortalWeb.API.V1 do
      resources "/companies", CompanyController, except: [:new, :edit]

      resources "/pads", PadController, except: [:new, :edit]
      resources "/wells", WellController, except: [:new, :edit]

      resources "/stages", StageController, except: [:new, :edit]
      resources "/clusters", ClusterController, except: [:new, :edit]
      resources "/perforations", PerforationController, except: [:new, :edit]
    end

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  # Other scopes may use custom stacks.
  # scope "/api", PerfPortalWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:perf_portal, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PerfPortalWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
