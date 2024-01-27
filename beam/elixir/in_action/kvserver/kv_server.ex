defmodule KeyValueStore do
  use GenServer

  @impl GenServer
  def init(_) do
    # handle_info example:
    # :time.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  # handle_info example:
  # def handle_info(:cleanup, state) do
  #  IO.puts "preforming cleanup"
  #  {:noreply, state}
  # end

  # Abstract around the protocol
  def start do
    GenServer.start(KeyValueStore, nil)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end
end
