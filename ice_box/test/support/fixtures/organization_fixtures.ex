defmodule IceBox.OrganizationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IceBox.Organization` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: Ecto.UUID.generate()
      })
      |> IceBox.Organization.create_company()

    company
  end

  @doc """
  Generate a company and a restaurant
  """
  def company_and_restaurant_fixture(attrs \\ %{}) do
    %{id: company_id} = company_fixture()

    {:ok, restaurant} =
      attrs
      |> Enum.into(%{
        address: "some address",
        company_id: company_id,
        email: "some email",
        name: "some name",
        phone: "some phone",
        website: "some website"
      })
      |> IceBox.Organization.create_restaurant()

    restaurant
  end

  @doc """
  Generate a restaurant given a company id
  """
  def restaurant_fixture(company_id, attrs \\ %{}) do
    {:ok, restaurant} =
      attrs
      |> Enum.into(%{
        address: "some address",
        company_id: company_id,
        email: "some email",
        name: "some name",
        phone: "some phone",
        website: "some website"
      })
      |> IceBox.Organization.create_restaurant()

    restaurant
  end
end
