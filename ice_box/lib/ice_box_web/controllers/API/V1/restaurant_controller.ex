defmodule IceBoxWeb.API.V1.RestaurantController do
  use IceBoxWeb, :controller

  alias IceBox.Organization
  alias IceBox.Organization.Restaurant

  action_fallback IceBoxWeb.FallbackController

  def index(conn, _params) do
    restaurants = Organization.list_restaurants()
    render(conn, :index, restaurants: restaurants)
  end

  def create(conn, %{"restaurant" => restaurant_params}) do
    with {:ok, %Restaurant{} = restaurant} <- Organization.create_restaurant(restaurant_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/restaurant/#{restaurant}")
      |> render(:show, restaurant: restaurant)
    end
  end

  def show(conn, %{"id" => id}) do
    restaurant = Organization.get_restaurant!(id)
    render(conn, :show, restaurant: restaurant)
  end

  def update(conn, %{"id" => id, "restaurant" => restaurant_params}) do
    restaurant = Organization.get_restaurant!(id)

    with {:ok, %Restaurant{} = restaurant} <-
           Organization.update_restaurant(restaurant, restaurant_params) do
      render(conn, :show, restaurant: restaurant)
    end
  end

  def delete(conn, %{"id" => id}) do
    restaurant = Organization.get_restaurant!(id)

    with {:ok, %Restaurant{}} <- Organization.delete_restaurant(restaurant) do
      send_resp(conn, :no_content, "")
    end
  end
end
