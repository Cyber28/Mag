defmodule Mag.Server do
  use Ace.HTTP.Service, port: 8000, cleartext: true
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: []}, _) do
    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("Mag is running properly!")
  end

  def handle_request(%{method: :GET, path: ["village-plus-plus"]}, _) do
    seed =
      if Mag.Cache.length() == 0,
        do: Mag.Generator.generate_seed() |> Map.put(:cached, false),
        else: Mag.Cache.get()

    response(:ok)
    |> set_header("content-type", "application/json")
    |> set_body(Jason.encode!(seed))
  end

  def handle_request(_, _) do
    response(:not_found)
    |> set_header("content-type", "text/plain")
    |> set_body("Not found")
  end
end
