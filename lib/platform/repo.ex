defmodule Platform.Repo do
  use Ecto.Repo,
    otp_app: :platform,
    adapter: Ecto.Adapters.SQLite3
end
