defmodule PermissionDemoWeb.Router do
  use PermissionDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PermissionDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: PermissionDemoWeb.ApiSpec
  end

  scope "/" do
    pipe_through :browser
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "api/openapi"
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    scope "/v1", PermissionDemoWeb.API.V1 do
      resources "/grants", GrantController, except: [:new, :update, :edit]
      resources "/users", UserController, except: [:new, :update, :edit]
      resources "/permissions", PermissionController, except: [:new, :update, :edit]

      resources "/permission_decision", PermissionDecisionController, only: [:create]
    end

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:permission_demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PermissionDemoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
