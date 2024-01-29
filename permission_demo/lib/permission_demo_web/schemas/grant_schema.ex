defmodule PermissionDemoWeb.OpenApiSchemas.Grant do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Request do
    OpenApiSpex.schema(%{
      title: "Grant Request",
      type: :object,
      properties: %{
        user_id: %Schema{type: :string, format: :uuid},
        permission_id: %Schema{type: :string, format: :uuid}
      }
    })
  end

  defmodule CreateRequest do
    OpenApiSpex.schema(%{
      title: "Create Grant Request",
      type: :object,
      properties: %{
        grant: Request
      }
    })
  end

  defmodule Response do
    OpenApiSpex.schema(%{
      title: "Grant Response",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        user_id: %Schema{type: :string, format: :uuid},
        permission_id: %Schema{type: :string, format: :uuid},
        inserted_at: %Schema{
          type: :string,
          pattern: ~r/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/
        },
        updated_at: %Schema{
          type: :string,
          pattern: ~r/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/
        }
      }
    })
  end

  defmodule ListResponse do
    OpenApiSpex.schema(%{
      title: "List Grant Response",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Response}
      }
    })
  end
end
