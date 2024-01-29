defmodule PerfPortalWeb.API.V1.CompanyControllerTest do
  use PerfPortalWeb.ConnCase

  import PerfPortal.ClientsFixtures

  alias PerfPortal.Clients.Company

  alias OpenApiSpex.TestAssertions

  @api_spec PerfPortalWeb.ApiSpec.spec()

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/companies")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create company" do
    test "renders company when data is valid", %{conn: conn} do
      %{"id" => id} =
        conn
        |> post(~p"/api/v1/companies", company: @create_attrs)
        |> json_response(201)
        |> Map.get("data")

      company =
        conn
        |> get(~p"/api/v1/companies/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(company, "Company Response", @api_spec)
      assert company["id"] == id
      assert company["name"] == Map.get(@create_attrs, :name)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/companies", company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update company" do
    setup [:create_company]

    test "renders company when data is valid", %{conn: conn, company: %Company{id: id} = company} do
      conn
      |> put(~p"/api/v1/companies/#{company}", company: @update_attrs)
      |> json_response(200)

      company =
        conn
        |> get(~p"/api/v1/companies/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(company, "Company Response", @api_spec)
      assert company["id"] == id
      assert company["name"] == Map.get(@update_attrs, :name)
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, ~p"/api/v1/companies/#{company}", company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, ~p"/api/v1/companies/#{company}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/companies/#{company}")
      end
    end
  end

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end
end
