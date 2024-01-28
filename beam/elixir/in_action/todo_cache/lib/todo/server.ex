defmodule Todo.Server do
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new()}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  @impl GenServer
  def handle_cast({:update_entry, old_entry_id, updater}, todo_list) do
    {:noreply, Todo.List.update_entry(todo_list, old_entry_id, updater)}
  end

  @impl GenServer
  def handle_cast({:delete_entry, target_entry_id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, target_entry_id)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_call({:get_todo_list}, _, todo_list) do
    {:reply, todo_list, todo_list}
  end

  # Abstract around the protocol

  def start do
    GenServer.start(Todo.Server, nil)
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
