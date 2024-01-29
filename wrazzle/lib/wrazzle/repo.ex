defmodule Wrazzle.Repo do
  use Ecto.Repo,
    otp_app: :wrazzle,
    adapter: Ecto.Adapters.Postgres
end
