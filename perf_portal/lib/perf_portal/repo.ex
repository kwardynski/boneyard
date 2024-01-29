defmodule PerfPortal.Repo do
  use Ecto.Repo,
    otp_app: :perf_portal,
    adapter: Ecto.Adapters.Postgres
end
