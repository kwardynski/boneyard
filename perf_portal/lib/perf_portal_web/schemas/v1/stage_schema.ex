defmodule PerfPortalWeb.Schemas.V1.Stage do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Request do
    OpenApiSpex.schema(%{
      title: "Stage Request",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        well_id: %Schema{type: :string, format: :uuid}
      }
    })
  end

  defmodule CreateRequest do
    OpenApiSpex.schema(%{
      title: "Create a Stage Request",
      type: :object,
      properties: %{
        stage: Request
      }
    })
  end

  defmodule UpdateRequest do
    OpenApiSpex.schema(%{
      title: "Update Stage Request",
      type: :object,
      properties: %{
        stage: Request
      }
    })
  end

  defmodule Response do
    OpenApiSpex.schema(%{
      title: "Stage Response",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        well_id: %Schema{type: :string, format: :uuid},
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
      title: "List Stages Response",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Response}
      }
    })
  end
end
