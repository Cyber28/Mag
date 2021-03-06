defmodule Mag do
  def get_port() do
    case System.fetch_env("MAG_PORT") do
      :error -> 8000
      {:ok, port} -> String.to_integer(port)
    end
  end

  def get_max_cache() do
    case System.fetch_env("MAG_MAX_CACHE") do
      :error -> 10
      {:ok, max_cache} -> String.to_integer(max_cache)
    end
  end

  def get_max_generators() do
    case System.fetch_env("MAG_MAX_GENERATORS") do
      :error -> 1
      {:ok, max_generators} -> String.to_integer(max_generators)
    end
  end
end
