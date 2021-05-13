defmodule Mag.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Mag.Server, []},
      Mag.Cache
    ]

    opts = [strategy: :one_for_one, name: Mag.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
