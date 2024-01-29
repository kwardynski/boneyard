defmodule PermissionDemoWeb.OpenApiSchemas.PermissionDecision do
  @moduledoc false
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Request do
    @moduledoc false
    OpenApiSpex.schema(%{
      title: "Permission Decision Request",
      type: :object,
      properties: %{
        permissions: %Schema{type: :array, items: %Schema{type: :string}},
        user_id: %Schema{type: :string, format: :uuid},
        method: %Schema{type: :string, default: "slow", enum: ["slow", "fast"]}
      }
    })
  end

  defmodule Response do
    @moduledoc false
    OpenApiSpex.schema(%{
      title: "Permission Decision Response",
      type: :object,
      additionalProperties: %Schema{type: :boolean}
    })
  end
end
