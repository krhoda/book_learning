defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
      # Destructures to:
      # fn entry, todo_list_acc ->
      # 	add_entry(todo_list_acc, entry)
      # end
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)

    %TodoList{
      todo_list
      | entries: new_entries,
        auto_id: todo_list.auto_id + 1
    }
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  # NOTE: The better way would be to use an Entry struct and spec while we're at it.
  def update_entry(todo_list, entry_id, updater) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end
end

defmodule TodoServer do
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, TodoList.new()}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, new_entry)}
  end

  @impl GenServer
  def handle_cast({:update_entry, old_entry_id, updater}, todo_list) do
    {:noreply, TodoList.update_entry(todo_list, old_entry_id, updater)}
  end

  @impl GenServer
  def handle_cast({:delete_entry, target_entry_id}, todo_list) do
    {:noreply, TodoList.delete_entry(todo_list, target_entry_id)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_call({:get_todo_list}, _, todo_list) do
    {:reply, todo_list, todo_list}
  end

  # Abstract around the protocol

  def start do
    GenServer.start(TodoServer, nil)
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def update_entry(todo_server, old_entry_id, updater) do
    GenServer.cast(todo_server, {:update_entry, old_entry_id, updater})
  end

  def delete_entry(todo_server, target_entry_id) do
    GenServer.cast(todo_server, {:delete_entry, target_entry_id})
  end

  def get_todo_list(todo_server) do
    GenServer.call(todo_server, {:get_todo_list})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end
end
