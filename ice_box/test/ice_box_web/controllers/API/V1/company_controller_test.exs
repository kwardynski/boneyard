defmodule IceBoxWeb.API.V1.CompanyControllerTest do
  use IceBoxWeb.ConnCase
  import OpenApiSpex.TestAssertions

  import IceBox.OrganizationFixtures

  alias IceBox.Organization.Company

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  @api_spec IceBoxWeb.ApiSpec.spec()

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list if no companies saved", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/company")
      assert json_response(conn, 200)["data"] == []
    end

    test "returns a list of companies", %{conn: conn} do
      # GIVEN 3 companies
      company_names =
        for _ <- 1..3 do
          %{name: name} = company_fixture(%{name: Ecto.UUID.generate()})
          name
        end

      # WHEN indexing for companies
      index_response =
        conn
        |> get(~p"/api/v1/company")
        |> json_response(200)

      assert_schema(index_response, "CompanyListResponse", @api_spec)

      # THEN three companies are returned
      returned_companies = index_response["data"]
      assert length(returned_companies) == 3
      assert Enum.all?(returned_companies, &(&1["name"] in company_names))
    end
  end

  describe "create company" do
    test "renders company when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/company", @create_attrs)
      assert_request_schema(@create_attrs, "CompanyRequest", @api_spec)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/company/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/company", company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 422 when attempting to create a company with duplicate name", %{conn: conn} do
      # GIVEN a company with a name
      name = Ecto.UUID.generate()
      company_fixture(%{name: name})

      # WHEN attempting to create another company with the same name
      error_response =
        conn
        |> post(~p"/api/v1/company", %{name: name})
        |> json_response(422)

      # THEN the company cannot be created
      assert %{"errors" => %{"name" => ["has already been taken"]}} = error_response
    end
  end

  describe "update company" do
    setup [:create_company]

    test "renders company when data is valid", %{conn: conn, company: %Company{id: id} = company} do
      conn = put(conn, ~p"/api/v1/company/#{company}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
      conn = get(conn, ~p"/api/v1/company/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, ~p"/api/v1/company/#{company}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 422 when updating a company to a name already in use", %{conn: conn} do
      # GIVEN a company named company_1
      company_fixture(%{name: "company_1"})

      # AND another company named company_2
      company_2 = company_fixture(%{name: "company_2"})

      # WHEN attempting to rename company_2 to company_1
      error_response =
        conn
        |> put(~p"/api/v1/company/#{company_2}", %{name: "company_1"})
        |> json_response(422)

      # THEN the company name cannot be updated
      assert %{"errors" => %{"name" => ["has already been taken"]}} = error_response
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, ~p"/api/v1/company/#{company}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/company/#{company}")
      end
    end
  end

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end
end
