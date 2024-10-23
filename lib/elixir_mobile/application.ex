defmodule ElixirMobile.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirMobileWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:elixir_mobile, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirMobile.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirMobile.Finch},
      # Start a worker by calling: ElixirMobile.Worker.start_link(arg)
      # {ElixirMobile.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirMobileWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMobile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirMobileWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
