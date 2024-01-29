defmodule Budgee.Repo do
  use Ecto.Repo,
    otp_app: :budgee,
    adapter: Ecto.Adapters.Postgres
end
