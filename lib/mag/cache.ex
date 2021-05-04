defmodule Mag.Cache do
  use GenServer

  # Client

  def start_link(l) do
    GenServer.start_link(__MODULE__, l, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def length() do
    GenServer.call(__MODULE__, :length)
  end

  def put(data) do
    GenServer.call(__MODULE__, {:put, data})
  end

  # Server

  @impl true
  def init(l) do
    {:ok, l}
  end

  @impl true
  def handle_call(:get, _, state) do
    if length(state) == 0 do
      {:reply, :error, state}
    else
      [head | tail] = state
      {:reply, head, tail}
    end
  end

  def handle_call(:length, _, state) do
    {:reply, length(state), state}
  end

  @impl true
  def handle_call({:put, data}, _, state) do
    {:reply, :ok, [data | state]}
  end
end
