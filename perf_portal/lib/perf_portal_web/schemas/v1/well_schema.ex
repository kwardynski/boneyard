defmodule PerfPortalWeb.Schemas.V1.Well do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Request do
    OpenApiSpex.schema(%{
      title: "Well Request",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        company_id: %Schema{type: :string, format: :uuid},
        pad_id: %Schema{type: :string, format: :uuid}
      }
    })
  end

  defmodule CreateRequest do
    OpenApiSpex.schema(%{
      title: "Create a Well Request",
      type: :object,
      properties: %{
        well: Request
      }
    })
  end

  defmodule UpdateRequest do
    OpenApiSpex.schema(%{
      title: "Update Well Request",
      type: :object,
      properties: %{
        well: Request
      }
    })
  end

  defmodule Response do
    OpenApiSpex.schema(%{
      title: "Well Response",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        company_id: %Schema{type: :string, format: :uuid},
        pad_id: %Schema{type: :string, format: :uuid},
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
      title: "List Wells Response",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Response}
      }
    })
  end
end
