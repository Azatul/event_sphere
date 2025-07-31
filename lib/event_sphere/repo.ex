defmodule EventSphere.Repo do
  use Ecto.Repo,
    otp_app: :event_sphere,
    adapter: Ecto.Adapters.Postgres
end
