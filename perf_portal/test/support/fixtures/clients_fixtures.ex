defmodule PerfPortal.ClientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PerfPortal.Clients` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    default_attrs = %{name: Ecto.UUID.generate()}
    create_attrs = Map.merge(default_attrs, attrs)
    {:ok, company} = PerfPortal.Clients.create_company(create_attrs)

    company
  end
end
