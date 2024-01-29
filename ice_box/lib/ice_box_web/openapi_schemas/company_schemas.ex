defmodule IceBoxWeb.Schemas.Company do
  @moduledoc false

  alias OpenApiSpex.Schema

  require OpenApiSpex

  defmodule Request do
    @moduledoc false
    OpenApiSpex.schema(%{
      title: "CompanyRequest",
      description: "Company Request Schema",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Company Name"}
      },
      required: [:name],
      example: %{
        name: "Generic Restaurant Group"
      }
    })
  end

  defmodule Response do
    @moduledoc false
    OpenApiSpex.schema(%{
      title: "CompanyResponse",
      description: "Company Response Schema",
      type: :object,
      properties: %{
        data: IceBoxWeb.Schemas.Company.Request
      },
      example: %{
        "data" => %{
          "id" => "d88f9929-c724-4c7d-9810-8b4989c92b52",
          "name" => "Generic Restaurant Group"
        }
      }
    })
  end

  defmodule ListResponse do
    @moduledoc false
    OpenApiSpex.schema(%{
      title: "CompanyListResponse",
      description: "Company List Response Schema",
      type: :object,
      properties: %{
        data: %Schema{type: :array, items: IceBoxWeb.Schemas.Company.Request}
      },
      example: %{
        "data" => [
          %{
            "id" => "d88f9929-c724-4c7d-9810-8b4989c92b52",
            "name" => "Generic Restaurant Group"
          },
          %{
            "id" => "6020dabd-7cd6-4adf-8cdd-af191855e3d6",
            "name" => "Gentrified Brewery and Gastropub"
          }
        ]
      }
    })
  end
end
