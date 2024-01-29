defmodule PerfPortal.Clients do
  @moduledoc """
  The Clients context.
  """

  import Ecto.Query, warn: false
  alias PerfPortal.Clients.Company
  alias PerfPortal.Repo

  def list_companies do
    Repo.all(Company)
  end

  def get_company!(id), do: Repo.get!(Company, id)

  def create_company(attrs \\ %{}) do
    attrs
    |> Company.create_changeset()
    |> Repo.insert()
  end

  def update_company(%Company{} = company, attrs) do
    company
    |> Company.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end
end
