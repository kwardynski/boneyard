defmodule PermissionDemo.Repo do
  use Ecto.Repo,
    otp_app: :permission_demo,
    adapter: Ecto.Adapters.Postgres
end
