defmodule PerfPortal.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PerfPortal.Assets` context.
  """

  alias PerfPortal.Assets
  alias PerfPortal.Assets.Pad
  alias PerfPortal.Clients.Company

  def pad_fixture(%Company{} = company, attrs \\ %{}) do
    default_attrs = %{name: Ecto.UUID.generate()}
    create_attrs = Map.merge(default_attrs, attrs)
    {:ok, pad} = Assets.create_pad(company, create_attrs)

    pad
  end

  def well_fixture(%Pad{} = pad, attrs \\ %{}) do
    default_attrs = %{name: Ecto.UUID.generate()}
    create_attrs = Map.merge(default_attrs, attrs)
    {:ok, well} = Assets.create_well(pad, create_attrs)

    well
  end
end
