defmodule PerfPortal.ClientsTest do
  use PerfPortal.DataCase

  import PerfPortal.ClientsFixtures

  alias PerfPortal.Clients
  alias PerfPortal.Clients.Company

  describe "companies" do
    @invalid_attrs %{name: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Clients.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Clients.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Company{} = company} = Clients.create_company(valid_attrs)
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Company{} = company} = Clients.update_company(company, update_attrs)
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_company(company, @invalid_attrs)
      assert company == Clients.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Clients.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_company!(company.id) end
    end
  end
end
