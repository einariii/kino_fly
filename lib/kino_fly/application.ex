defmodule KinoFly.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoFly)

    children = []
    opts = [strategy: :one_for_one, name: KinoFly.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
