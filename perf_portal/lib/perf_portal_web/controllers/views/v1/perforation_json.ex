defmodule PerfPortalWeb.API.V1.PerforationJSON do
  alias PerfPortal.Completions.Perforation

  def index(%{perforations: perforations}) do
    %{data: for(perforation <- perforations, do: data(perforation))}
  end

  def show(%{perforation: perforation}) do
    %{data: data(perforation)}
  end

  defp data(%Perforation{} = perforation) do
    %{
      id: perforation.id,
      name: perforation.name,
      phase: perforation.phase,
      depth: perforation.depth,
      exit_diameter: perforation.exit_diameter,
      exit_diameter_increase: perforation.exit_diameter_increase,
      cluster_id: perforation.cluster_id
    }
  end
end
