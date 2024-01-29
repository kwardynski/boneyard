defmodule BudgeeWeb.PageController do
  use BudgeeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
