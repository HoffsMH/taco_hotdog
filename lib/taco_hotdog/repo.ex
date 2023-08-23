defmodule TacoHotdog.Repo do
  use Ecto.Repo,
    otp_app: :taco_hotdog,
    adapter: Ecto.Adapters.Postgres
end
