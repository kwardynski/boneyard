defmodule PerfPortalWeb.API.V1.WellJSON do
  alias PerfPortal.Assets.Well

  @doc """
  Renders a list of wells.
  """
  def index(%{wells: wells}) do
    %{data: for(well <- wells, do: data(well))}
  end

  @doc """
  Renders a single well.
  """
  def show(%{well: well}) do
    %{data: data(well)}
  end

  defp data(%Well{} = well) do
    %{
      id: well.id,
      name: well.name,
      company_id: well.company_id,
      pad_id: well.pad_id
    }
  end
end
