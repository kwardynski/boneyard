defmodule PerfPortalWeb.Schemas.V1.Perforation do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Request do
    OpenApiSpex.schema(%{
      title: "Perforation Request",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        cluster_id: %Schema{type: :string, format: :uuid},
        depth: %Schema{type: :number},
        phase: %Schema{type: :number},
        exit_diameter: %Schema{type: :number},
        exit_diameter_increase: %Schema{type: :number}
      }
    })
  end

  defmodule CreateRequest do
    OpenApiSpex.schema(%{
      title: "Create a Perforation Request",
      type: :object,
      properties: %{
        perforation: Request
      }
    })
  end

  defmodule UpdateRequest do
    OpenApiSpex.schema(%{
      title: "Update Perforation Request",
      type: :object,
      properties: %{
        perforation: Request
      }
    })
  end

  defmodule Response do
    OpenApiSpex.schema(%{
      title: "Perforation Response",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        cluster_id: %Schema{type: :string, format: :uuid},
        depth: %Schema{type: :number},
        phase: %Schema{type: :number},
        exit_diameter: %Schema{type: :number},
        exit_diameter_increase: %Schema{type: :number},
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
      title: "List Perforations Response",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: Response}
      }
    })
  end
end
