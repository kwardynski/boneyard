defmodule PermissionDemoWeb.API.V1.PermissionDecisionController do
  use PermissionDemoWeb, :controller
  use OpenApiSpex.ControllerSpecs
  require Logger

  alias PermissionDemo.Accounts
  alias PermissionDemo.Permissions

  alias PermissionDemoWeb.OpenApiSchemas.PermissionDecision.Request
  alias PermissionDemoWeb.OpenApiSchemas.PermissionDecision.Response

  action_fallback PermissionDemoWeb.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true
  tags ["Permission Decisions"]

  operation :create,
    summary: "Validate which Permissions have been granted to a User",
    request_body: {"Permission Decisions", "application/json", Request},
    responses: [
      ok: {"Permission Decisions", "application/json", Response}
    ]

  def create(conn, _params) do
    %{
      user_id: user_id,
      permissions: permissions,
      method: method
    } = conn.body_params

    {call_time, validated_permissions} =
      :timer.tc(fn -> validate_permissions(method, user_id, permissions) end)

    Logger.info("#{method}: #{call_time}")

    conn
    |> put_status(200)
    |> json(validated_permissions)
  end

  defp validate_permissions("slow", user_id, permissions) do
    user_id
    |> Accounts.available_permissions()
    |> Permissions.permissions_granted?(permissions)
  end

  defp validate_permissions("fast", user_id, permissions) do
    user_id
    |> Accounts.matching_permissions(permissions)
    |> Permissions.permissions_granted?(permissions)
  end
end
