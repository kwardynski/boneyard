defmodule PerfPortalWeb.API.V1.StageJSON do
  alias PerfPortal.Completions.Stage

  def index(%{stages: stages}) do
    %{data: for(stage <- stages, do: data(stage))}
  end

  def show(%{stage: stage}) do
    %{data: data(stage)}
  end

  defp data(%Stage{} = stage) do
    %{
      id: stage.id,
      name: stage.name,
      well_id: stage.well_id
    }
  end
end
