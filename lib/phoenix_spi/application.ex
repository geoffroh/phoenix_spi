defmodule PhoenixSpi.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      supervisor(PhoenixSpi.Repo, []),
      supervisor(PhoenixSpiWeb.Endpoint, []),
      worker(PhoenixSpi.Executable, ["/Applications/SonicPi.app/app/server/native/ruby/bin/ruby", "/Applications/SonicPi.app/app/server/ruby/bin/sonic-pi-server.rb"], id: :sonic_pi_server),
      worker(PhoenixSpi.Executable, ["/usr/local/bin/oscdump", "osc.udp://:4558"], id: :sonic_pi_log),
    ]

    opts = [strategy: :one_for_one, name: PhoenixSpi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixSpiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
