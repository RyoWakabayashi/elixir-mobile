defmodule ElixirMobile do
  use Application

  def config_dir() do
    Path.join([Desktop.OS.home(), ".config", "elixir_mobile"])
  end

  @app Mix.Project.config()[:app]
  def start(:normal, []) do
    File.mkdir_p!(config_dir())

    :session = :ets.new(:session, [:named_table, :public, read_concurrency: true])

    children = [
      {Phoenix.PubSub, name: ElixirMobile.PubSub},
      {Finch, name: ElixirMobile.Finch},
      ElixirMobileWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ElixirMobile.Supervisor]
    {:ok, sup} = Supervisor.start_link(children, opts)

    {:ok, {_ip, port}} = Bandit.PhoenixAdapter.server_info(ElixirMobileWeb.Endpoint, :http)

    {:ok, _} =
      Supervisor.start_child(sup, {
        Desktop.Window,
        [
          app: @app,
          id: ElixirMobileWindow,
          title: "elixir_mobile",
          size: {400, 800},
          url: "http://localhost:#{port}"
        ]
      })
  end

  def config_change(changed, _new, removed) do
    ElixirMobileWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
