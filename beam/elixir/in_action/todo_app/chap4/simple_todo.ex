# Dupe of "todo-multi_dict.ex"
defmodule MultiDict do
  def new(), do: %{}

  def add_entry(dict, key, value) do
    Map.update(dict, key, [value], &[value | &1])
  end

  def entries(dict, key) do
    Map.get(dict, key, [])
  end
end

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

defmodule TodoList.CsvImporter do
  def import(path) do
	l = File.stream!(path)
	|> Stream.map(&String.replace(&1, "\n", ""))
	|> Stream.map(&String.split(&1, ","))
	|> Stream.map(fn [date, title] -> [String.replace(date, "/", "-"), title] end)
	|> Enum.map(fn [date, title] -> %{date: Date.from_iso8601(date), title: title} end)

	TodoList.new(l)
  end
end
