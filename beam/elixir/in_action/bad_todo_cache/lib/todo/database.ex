defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
	key
	|> choose_worker()
	|> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
	key
	|> choose_worker()
	|> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
	GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    m = Map.put(%{}, 0, Todo.DatabaseWorker.start(@db_folder))
    m = Map.put(m, 1, Todo.DatabaseWorker.start(@db_folder))
    m = Map.put(m, 2, Todo.DatabaseWorker.start(@db_folder))

    {:ok, m}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, state) do
    {:reply, Map.get(state, :erlang.phash2(key, 3)), state}
  end
end
