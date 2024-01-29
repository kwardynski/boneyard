defmodule IceBox.Repo do
  use Ecto.Repo,
    otp_app: :ice_box,
    adapter: Ecto.Adapters.Postgres
end
