defmodule Mag.Cache do
  use GenServer

  # Client

  def start_link(_) do
    generators = File.ls!("./generators")
    caches = Map.new(generators, fn g -> {g, []} end)

    Enum.each(generators, fn g -> Task.start(fn -> Mag.Generator.run(g) end) end)

    GenServer.start_link(__MODULE__, caches, name: __MODULE__)
  end

  def exists?(name) do
    GenServer.call(__MODULE__, {:exists, name})
  end

  def get(name) do
    if exists?(name), do: GenServer.call(__MODULE__, {:get, name}), else: :error
  end

  def size(name) do
    if exists?(name), do: GenServer.call(__MODULE__, {:size, name}), else: :error
  end

  def all_sizes() do
    GenServer.call(__MODULE__, :all_sizes)
  end

  def put(name, data) do
    if exists?(name), do: GenServer.call(__MODULE__, {:put, name, data}), else: :error
  end

  # Server

  @impl true
  def init(l) do
    {:ok, l}
  end

  @impl true
  def handle_call({:exists, name}, _, state) do
    {:reply, Map.has_key?(state, name), state}
  end

  def handle_call({:get, name}, _, state) do
    if length(state[name]) == 0 do
      {:reply, :error, state}
    else
      [head | tail] = state[name]
      {:reply, head, Map.put(state, name, tail)}
    end
  end

  def handle_call({:size, name}, _, state) do
    {:reply, length(state[name]), state}
  end

  def handle_call(:all_sizes, _, state) do
    {:reply, Map.new(state, fn {name, values} -> {name, length(values)} end), state}
  end

  def handle_call({:put, name, data}, _, state) do
    {:reply, :ok, Map.put(state, name, [data | state[name]])}
  end
end
