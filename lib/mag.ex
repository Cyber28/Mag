defmodule Mag do
  def get_port() do
    case System.fetch_env("MAG_PORT") do
      :error -> 8000
      {:ok, port} -> String.to_integer(port)
    end
  end
end
