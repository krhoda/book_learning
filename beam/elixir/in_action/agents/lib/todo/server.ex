defmodule Todo.Server do
  use Agent, restart: :temporary

  def start_link(name) do
    Agent.start_link(
      fn ->
        IO.puts("Starting to-do server for #{name}")
        {name, Todo.Database.get(name) || Todo.List.new()}
      end,
      name: via_tuple(name)
    )
  end

  def add_entry(todo_server, new_entry) do
    Agent.cast(todo_server, fn {name, todo_list} ->
      next = Todo.List.add_entry(todo_list, new_entry)
      Todo.Database.store(name, next)
      {name, next}
    end)
  end

  def update_entry(todo_server, old_entry_id, updater) do
    Agent.cast(todo_server, fn {name, todo_list} ->
      next = Todo.List.update_entry(todo_list, old_entry_id, updater)
      Todo.Database.store(name, next)
      {name, next}
    end)
  end

  def delete_entry(todo_server, target_entry_id) do
    Agent.cast(todo_server, fn {name, todo_list} ->
      next = Todo.List.delete_entry(todo_list, target_entry_id)
      Todo.Database.store(name, next)
      {name, next}
    end)
  end

  def get_todo_list(todo_server) do
    Agent.get(todo_server, fn {_name, todo_list} -> todo_list end)
  end

  def entries(todo_server, date) do
    Agent.get(
      todo_server,
      fn {_name, todo_list} -> Todo.List.entries(todo_list, date) end
    )
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
