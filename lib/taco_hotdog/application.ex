defmodule TacoHotdog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TacoHotdogWeb.Telemetry,
      # Start the Ecto repository
      TacoHotdog.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TacoHotdog.PubSub},
      # Start Finch
      {Finch, name: TacoHotdog.Finch},
      {ConCache,
        [
          name: :polls,
          ttl_check_interval: :timer.seconds(1),
          global_ttl: :timer.seconds(60 * 5),
        ],
      },
      # Start the Endpoint (http/https)
      TacoHotdogWeb.Endpoint
      # Start a worker by calling: TacoHotdog.Worker.start_link(arg)
      # {TacoHotdog.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TacoHotdog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TacoHotdogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
