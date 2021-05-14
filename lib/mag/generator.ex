defmodule Mag.Generator do
  def run(name) do
    if Mag.Cache.size(name) >= Mag.get_max_cache() do
      Process.sleep(1_000)
      run(name)
    else
      Mag.Cache.put(name, generate_seed(name) |> Map.put(:cache_status, true))
      run(name)
    end
  end

  def generate_seed(name) do
    # providing a relative path is probably dumb
    gens = Mag.get_max_generators()
    ports = Enum.map(1..gens, fn _ -> Port.open({:spawn, "./generators/#{name}"}, [:binary]) end)

    recv_loop(ports, :os.system_time(:millisecond), name)
  end

  defp recv_loop(ports, start_time, name) do
    receive do
      {_port, {:data, data}} ->
        case String.starts_with?(data, "\nSeed: ") do
          false ->
            recv_loop(ports, start_time, name)

          true ->
            # Calling Port.info/1 to make sure the process still exists
            Enum.each(ports, fn port -> if Port.info(port) != nil, do: Port.close(port) end)

            seed =
              String.split(data, "\n")
              |> Enum.at(1)
              |> String.replace_prefix("Seed: ", "")
              |> String.to_integer()

            %{
              seed: seed,
              took: :os.system_time(:millisecond) - start_time
            }
        end
    end
  end
end
