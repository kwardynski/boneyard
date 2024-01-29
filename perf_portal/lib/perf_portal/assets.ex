defmodule PerfPortal.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false

  alias PerfPortal.Assets.Pad
  alias PerfPortal.Assets.Well
  alias PerfPortal.Clients.Company
  alias PerfPortal.Repo

  def list_pads do
    Repo.all(Pad)
  end

  def get_pad!(id), do: Repo.get!(Pad, id)

  def create_pad(%Company{} = company, attrs \\ %{}) do
    assoc_attrs = %{company_id: company.id}
    create_attrs = Map.merge(attrs, assoc_attrs)

    create_attrs
    |> Pad.create_changeset()
    |> Repo.insert()
  end

  def update_pad(%Pad{} = pad, attrs) do
    pad
    |> Pad.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_pad(%Pad{} = pad) do
    Repo.delete(pad)
  end

  def list_wells do
    Repo.all(Well)
  end

  def get_well!(id), do: Repo.get!(Well, id)

  def create_well(%Pad{} = pad, attrs \\ %{}) do
    assoc_attrs = %{company_id: pad.company_id, pad_id: pad.id}
    create_attrs = Map.merge(attrs, assoc_attrs)

    create_attrs
    |> Well.create_changeset()
    |> Repo.insert()
  end

  def update_well(%Well{} = well, attrs) do
    well
    |> Well.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_well(%Well{} = well) do
    Repo.delete(well)
  end
end
