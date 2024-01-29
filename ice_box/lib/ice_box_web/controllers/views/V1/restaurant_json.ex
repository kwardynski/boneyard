defmodule IceBoxWeb.API.V1.RestaurantJSON do
  alias IceBox.Organization.Restaurant

  @doc """
  Renders a list of restaurants.
  """
  def index(%{restaurants: restaurants}) do
    %{data: for(restaurant <- restaurants, do: data(restaurant))}
  end

  @doc """
  Renders a single restaurant.
  """
  def show(%{restaurant: restaurant}) do
    %{data: data(restaurant)}
  end

  defp data(%Restaurant{} = restaurant) do
    %{
      id: restaurant.id,
      company_id: restaurant.company_id,
      name: restaurant.name,
      address: restaurant.address,
      phone: restaurant.phone,
      email: restaurant.email,
      website: restaurant.website
    }
  end
end
