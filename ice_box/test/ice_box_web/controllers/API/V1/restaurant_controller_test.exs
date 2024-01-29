defmodule IceBoxWeb.API.V1.RestaurantControllerTest do
  use IceBoxWeb.ConnCase

  import IceBox.OrganizationFixtures

  alias IceBox.Organization.Restaurant

  @create_attrs %{
    address: "some address",
    company_id: "7488a646-e31f-11e4-aace-600308960662",
    email: "some email",
    name: "some name",
    phone: "some phone",
    website: "some website"
  }
  @update_attrs %{
    address: "some updated address",
    company_id: "7488a646-e31f-11e4-aace-600308960668",
    email: "some updated email",
    name: "some updated name",
    phone: "some updated phone",
    website: "some updated website"
  }
  @invalid_attrs %{address: nil, company_id: nil, email: nil, name: nil, phone: nil, website: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all restaurants", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/restaurant")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create restaurant" do
    test "renders restaurant when data is valid", %{conn: conn} do
      %{id: company_id} = company_fixture()
      create_attrs = Map.put(@create_attrs, :company_id, company_id)

      conn = post(conn, ~p"/api/v1/restaurant", restaurant: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/restaurant/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "company_id" => ^company_id,
               "email" => "some email",
               "name" => "some name",
               "phone" => "some phone",
               "website" => "some website"
             } = json_response(conn, 200)["data"]
    end

    test "respects unique restaurant name constraint", %{conn: conn} do
      # GIVEN a company with a restaurant
      restaurant_name = Ecto.UUID.generate()
      %{id: company_id} = company_fixture()
      restaurant_fixture(company_id, %{name: restaurant_name})

      # WHEN attempting to create another restaurant with that same name
      create_attrs =
        @create_attrs
        |> Map.put(:company_id, company_id)
        |> Map.put(:name, restaurant_name)

      error_response =
        conn
        |> post(~p"/api/v1/restaurant", restaurant: create_attrs)
        |> json_response(422)

      # THEN the restaurant cannot be created
      assert %{"errors" => %{"name" => ["has already been taken"]}} = error_response
    end

    test "will fail if company does not exist", %{conn: conn} do
      create_attrs = %{
        name: Ecto.UUID.generate(),
        company_id: Ecto.UUID.generate()
      }

      error_response =
        conn
        |> post(~p"/api/v1/restaurant", restaurant: create_attrs)
        |> json_response(422)

      assert %{"errors" => %{"company_id" => ["does not exist"]}} = error_response
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/restaurant", restaurant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update restaurant" do
    setup [:create_restaurant]

    test "renders restaurant when data is valid", %{
      conn: conn,
      restaurant: %Restaurant{id: id, company_id: company_id} = restaurant
    } do
      conn = put(conn, ~p"/api/v1/restaurant/#{restaurant}", restaurant: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/restaurant/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "company_id" => ^company_id,
               "email" => "some updated email",
               "name" => "some updated name",
               "phone" => "some updated phone",
               "website" => "some updated website"
             } = json_response(conn, 200)["data"]
    end

    test "respects unique restaurant name constraint", %{conn: conn} do
      # GIVEN a company with two restaurants
      %{id: company_id} = company_fixture()
      restaurant_fixture(company_id, %{name: "restaurant_1"})
      restaurant_2 = restaurant_fixture(company_id, %{name: "restaurant_2"})

      # WHEN attempting to rename restaurant_2 to restaurant_1
      update_attrs = %{name: "restaurant_1"}

      error_response =
        conn
        |> put(~p"/api/v1/restaurant/#{restaurant_2}", restaurant: update_attrs)
        |> json_response(422)

      # THEN the restaurant cannot be created
      assert %{"errors" => %{"name" => ["has already been taken"]}} = error_response
    end

    test "renders errors when data is invalid", %{conn: conn, restaurant: restaurant} do
      conn = put(conn, ~p"/api/v1/restaurant/#{restaurant}", restaurant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete restaurant" do
    setup [:create_restaurant]

    test "deletes chosen restaurant", %{conn: conn, restaurant: restaurant} do
      conn = delete(conn, ~p"/api/v1/restaurant/#{restaurant}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/restaurant/#{restaurant}")
      end
    end
  end

  defp create_restaurant(_) do
    restaurant = company_and_restaurant_fixture()
    %{restaurant: restaurant}
  end
end
