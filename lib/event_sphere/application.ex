defmodule EventSphere.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EventSphereWeb.Telemetry,
      EventSphere.Repo,
      {DNSCluster, query: Application.get_env(:event_sphere, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EventSphere.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EventSphere.Finch},
      # Start a worker by calling: EventSphere.Worker.start_link(arg)
      # {EventSphere.Worker, arg},
      # Start to serve requests, typically the last entry
      EventSphereWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventSphere.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventSphereWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
