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
  import MultiDict

  def new(), do: MultiDict.new()

  def add_entry(todo_list, entry) do
    MultiDict.add(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end
