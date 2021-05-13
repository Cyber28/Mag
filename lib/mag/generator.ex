defmodule Mag.Generator do
  def run(name) do
    if Mag.Cache.size(name) >= 10 do
      Process.sleep(1_000)
      run(name)
    else
      Mag.Cache.put(name, generate_seed(name) |> Map.put(:cache_status, true))
      run(name)
    end
  end

  def generate_seed(name) do
    # providing a relative path is probably dumb
    port = Port.open({:spawn, "./generators/#{name}"}, [:binary])

    recv_loop(port, :os.system_time(:millisecond), name)
  end

  defp recv_loop(port, start_time, name) do
    receive do
      {^port, {:data, data}} ->
        case String.starts_with?(data, "\nSeed: ") do
          false ->
            recv_loop(port, start_time, name)

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
