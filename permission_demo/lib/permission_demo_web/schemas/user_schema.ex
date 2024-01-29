defmodule PermissionDemoWeb.OpenApiSchemas.User do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Request do
    OpenApiSpex.schema(%{
      title: "User Request",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        email: %Schema{type: :string, format: :email}
      }
    })
  end

  defmodule CreateRequest do
    OpenApiSpex.schema(%{
      title: "Create User Request",
      type: :object,
      properties: %{
        user: Request
      }
    })
  end

  defmodule UpdateRequest do
    OpenApiSpex.schema(%{
      title: "Update User Request",
      type: :object,
      properties: %{
        user: Request
      }
    })
  end

  defmodule Response do
    OpenApiSpex.schema(%{
      title: "User Response",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        email: %Schema{type: :string, format: :email},
        permissions: %Schema{
          type: :array,
          items: PermissionDemoWeb.OpenApiSchemas.Permission.Response
        },
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
      title: "List User Response",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Response}
      }
    })
  end
end
