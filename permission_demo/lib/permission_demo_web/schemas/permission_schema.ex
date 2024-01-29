defmodule PermissionDemoWeb.OpenApiSchemas.Permission do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Request do
    OpenApiSpex.schema(%{
      title: "Permission Request",
      type: :object,
      properties: %{
        name: %Schema{type: :string}
      }
    })
  end

  defmodule CreateRequest do
    OpenApiSpex.schema(%{
      title: "Create Permission Request",
      type: :object,
      properties: %{
        permission: Request
      }
    })
  end

  defmodule UpdateRequest do
    OpenApiSpex.schema(%{
      title: "Update permission Request",
      type: :object,
      properties: %{
        permission: Request
      }
    })
  end

  defmodule Response do
    OpenApiSpex.schema(%{
      title: "Permission Response",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
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
      title: "List Permission Response",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Response}
      }
    })
  end
end
