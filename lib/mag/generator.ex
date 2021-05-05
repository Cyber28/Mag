defmodule Mag.Generator do
  def run() do
    if Mag.Cache.length() >= 10 do
      Process.sleep(1_000)
      run()
    else
      Mag.Cache.put(generate_seed() |> Map.put(:cached, true))
      run()
    end
  end

  def generate_seed() do
    # providing a relative path is probably dumb
    port = Port.open({:spawn, "./lib/mag/generators/village-plus-plus"}, [:binary])

    recv_loop(port, :os.system_time(:millisecond))
  end

  defp recv_loop(port, start_time) do
    receive do
      {^port, {:data, data}} ->
        case String.starts_with?(data, "\nSeed: ") do
          false ->
            recv_loop(port, start_time)

          true ->
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
