defmodule PerfPortalWeb.API.V1.CompanyJSON do
  alias PerfPortal.Clients.Company

  def index(%{companies: companies}) do
    %{data: for(company <- companies, do: data(company))}
  end

  def show(%{company: company}) do
    %{data: data(company)}
  end

  defp data(%Company{} = company) do
    %{
      id: company.id,
      name: company.name
    }
  end
end
