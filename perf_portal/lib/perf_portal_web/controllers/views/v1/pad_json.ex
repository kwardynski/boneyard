defmodule PerfPortalWeb.API.V1.PadJSON do
  alias PerfPortal.Assets.Pad

  def index(%{pads: pads}) do
    %{data: for(pad <- pads, do: data(pad))}
  end

  def show(%{pad: pad}) do
    %{data: data(pad)}
  end

  defp data(%Pad{} = pad) do
    %{
      id: pad.id,
      name: pad.name,
      company_id: pad.company_id
    }
  end
end
