defmodule Todo.Server do
  use GenServer, restart: :temporary

  @expiry_idle_timeout :timer.seconds(60)

  def start_link(name) do
    GenServer.start_link(Todo.Server, name, name: via_tuple(name))
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

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  @impl GenServer
  def init(name) do
    IO.puts("Starting to-do server for #{name}.")
    {:ok, {name, nil}, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, {name, nil}) do
    todo_list = Todo.Database.get(name) || Todo.List.new()
    {:noreply, {name, todo_list}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, {name, todo_list}) do
    IO.puts("Stopping idle todo server for #{name}")
    {:stop, :normal, {name, todo_list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_cast({:update_entry, old_entry_id, updater}, {name, todo_list}) do
    next = Todo.List.update_entry(todo_list, old_entry_id, updater)
    Todo.Database.store(name, next)
    {:noreply, {name, next}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_cast({:delete_entry, target_entry_id}, {name, todo_list}) do
    next = Todo.List.delete_entry(todo_list, target_entry_id)
    Todo.Database.store(name, next)
    {:noreply, {name, next}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_call({:get_todo_list}, _, {name, todo_list}) do
    {:reply, todo_list, {name, todo_list}, @expiry_idle_timeout}
  end
end
