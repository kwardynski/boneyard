defmodule IceBox.OrganizationTest do
  use IceBox.DataCase

  alias IceBox.Organization

  describe "companies" do
    alias IceBox.Organization.Company

    import IceBox.OrganizationFixtures

    @invalid_attrs %{name: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Organization.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Organization.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Company{} = company} = Organization.create_company(valid_attrs)
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organization.create_company(@invalid_attrs)
    end

    test "create_company/1 respects unique name constraint" do
      # GIVEN a company with a name
      name = Ecto.UUID.generate()
      {:ok, _company} = Organization.create_company(%{name: name})

      # WHEN attempting to create another company with the same name
      {:error, changeset} = Organization.create_company(%{name: name})

      # THEN the company cannot be created
      assert %{name: ["has already been taken"]} == errors_on(changeset)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Company{} = company} = Organization.update_company(company, update_attrs)
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Organization.update_company(company, @invalid_attrs)
      assert company == Organization.get_company!(company.id)
    end

    test "update_company/2 respects unique name constraint" do
      # GIVEN a company named company_1
      {:ok, _company_1} = Organization.create_company(%{name: "company_1"})

      # AND another company named company_2
      {:ok, company_2} = Organization.create_company(%{name: "company_2"})

      # WHEN attempting to rename company_2 to company_1
      {:error, changeset} = Organization.update_company(company_2, %{name: "company_1"})

      # THEN the unique name constraint is respected
      assert %{name: ["has already been taken"]} == errors_on(changeset)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Organization.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Organization.get_company!(company.id) end
    end
  end

  describe "restaurants" do
    alias IceBox.Organization.Restaurant

    import IceBox.OrganizationFixtures

    @invalid_attrs %{
      address: nil,
      company_id: nil,
      email: nil,
      name: nil,
      phone: nil,
      website: nil
    }

    test "list_restaurants/0 returns all restaurants" do
      restaurant = company_and_restaurant_fixture()
      assert Organization.list_restaurants() == [restaurant]
    end

    test "get_restaurant!/1 returns the restaurant with given id" do
      restaurant = company_and_restaurant_fixture()
      assert Organization.get_restaurant!(restaurant.id) == restaurant
    end

    test "create_restaurant/1 with valid data creates a restaurant" do
      %{id: company_id} = company_fixture()

      valid_attrs = %{
        address: "some address",
        company_id: company_id,
        email: "some email",
        name: "some name",
        phone: "some phone",
        website: "some website"
      }

      assert {:ok, %Restaurant{} = restaurant} = Organization.create_restaurant(valid_attrs)
      assert restaurant.address == "some address"
      assert restaurant.company_id == company_id
      assert restaurant.email == "some email"
      assert restaurant.name == "some name"
      assert restaurant.phone == "some phone"
      assert restaurant.website == "some website"
    end

    test "create_restaurant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organization.create_restaurant(@invalid_attrs)
    end

    test "create_restaurant/1 respects unique company_id/name constraint" do
      # GIVEN a company with a restaurant
      restaurant_name = Ecto.UUID.generate()
      %{id: company_id} = company_fixture()
      restaurant_fixture(company_id, %{name: restaurant_name})

      # WHEN attempting to create another restaurant with that same name
      {:error, changeset} =
        Organization.create_restaurant(%{
          company_id: company_id,
          name: restaurant_name
        })

      # THEN the restaurant cannot be created
      assert %{name: ["has already been taken"]} == errors_on(changeset)
    end

    test "restaurant cannot be created for a non-existent company" do
      invalid_attrs = %{
        company_id: Ecto.UUID.generate(),
        name: Ecto.UUID.generate()
      }

      {:error, changeset} = Organization.create_restaurant(invalid_attrs)
      assert %{company_id: ["does not exist"]} == errors_on(changeset)
    end

    test "update_restaurant/2 with valid data updates the restaurant" do
      restaurant = company_and_restaurant_fixture()

      update_attrs = %{
        address: "some updated address",
        email: "some updated email",
        name: "some updated name",
        phone: "some updated phone",
        website: "some updated website"
      }

      assert {:ok, %Restaurant{} = restaurant} =
               Organization.update_restaurant(restaurant, update_attrs)

      assert restaurant.address == "some updated address"
      assert restaurant.email == "some updated email"
      assert restaurant.name == "some updated name"
      assert restaurant.phone == "some updated phone"
      assert restaurant.website == "some updated website"
    end

    test "update_restaurant/2 with invalid data returns error changeset" do
      restaurant = company_and_restaurant_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organization.update_restaurant(restaurant, @invalid_attrs)

      assert restaurant == Organization.get_restaurant!(restaurant.id)
    end

    test "update_restaurant/2 respects unique company_id/name constraint" do
      # GIVEN a company with two restaurants
      %{id: company_id} = company_fixture()
      restaurant_fixture(company_id, %{name: "restaurant_1"})
      restaurant_2 = restaurant_fixture(company_id, %{name: "restaurant_2"})

      # WHEN attempting to rename restaurant_2 to restaurant_1
      {:error, changeset} =
        Organization.update_restaurant(
          restaurant_2,
          %{
            name: "restaurant_1"
          }
        )

      # THEN the restaurant cannot be created
      assert %{name: ["has already been taken"]} == errors_on(changeset)
    end

    test "delete_restaurant/1 deletes the restaurant" do
      restaurant = company_and_restaurant_fixture()
      assert {:ok, %Restaurant{}} = Organization.delete_restaurant(restaurant)
      assert_raise Ecto.NoResultsError, fn -> Organization.get_restaurant!(restaurant.id) end
    end
  end
end
