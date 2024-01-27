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
    Map.delete(todo_list.entries, entry_id)
  end
end

defmodule TodoServer do
  def start do
    spawn(fn -> loop(TodoList.new()) end)
  end

  defp loop(todo_list) do
    next =
      receive do
        m -> process_message(todo_list, m)
      end

    loop(next)
  end

  def add_entry(todo_server, new_entry) do
    send(todo_server, {:add_entry, new_entry})
  end

  def update_entry(todo_server, new_entry, updater) do
    send(todo_server, {:update_entry, new_entry, updater})
  end

  def delete_entry(todo_server, new_entry) do
    send(todo_server, {:delete_entry, new_entry})
  end

  def get_entries(todo_server) do
    send(todo_server, {:get_entries, self()})

    receive do
      {:response, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:update_entry, new_entry, updater}) do
    TodoList.update_entry(todo_list, new_entry.id, updater)
  end

  defp process_message(todo_list, {:delete_entry, new_entry}) do
    TodoList.delete_entry(todo_list, new_entry.id)
  end

  defp process_message(todo_list, {:get_entries, caller_pid}) do
	send(caller_pid, {:response, todo_list})
  end
end
