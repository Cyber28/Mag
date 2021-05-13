defmodule Mag.Server do
  use Ace.HTTP.Service, port: Mag.get_port(), cleartext: true
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(%{method: :GET, path: []}, _) do
    response(:ok)
    |> set_header("content-type", "text/plain")
    |> set_body("Mag is running properly!")
  end

  def handle_request(%{method: :GET, path: ["cache"]}, _) do
    response(:ok)
    |> set_header("content-type", "application/json")
    |> set_body(Jason.encode!(Mag.Cache.all_sizes()))
  end

  def handle_request(%{method: :GET, path: [name]}, _) do
    case Mag.Cache.exists?(name) do
      true ->
        seed =
          if Mag.Cache.size(name) == 0,
            do: Mag.Generator.generate_seed(name) |> Map.put(:cache_status, false),
            else: Mag.Cache.get(name)

        seed = seed |> Map.put(:cache_size, Mag.Cache.size(name))

        response(:ok)
        |> set_header("content-type", "application/json")
        |> set_body(Jason.encode!(seed))

      false ->
        response(:not_found)
        |> set_header("content-type", "application/json")
        |> set_body("Generator does not exist")
    end
  end

  def handle_request(_, _) do
    response(:not_found)
    |> set_header("content-type", "text/plain")
    |> set_body("Not found")
  end
end
