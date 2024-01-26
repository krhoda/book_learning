defmodule Geometry do
  def rectangle_area(a, b) do
    a * b
  end

  def square_area(a) do
    rectangle_area(a, a)
  end
end

defmodule Circle do
  @moduledoc """
  Implements basic circle functions
  """
  @pi 3.14159

  # Example Comment.

  @doc "Computes the area of a circle"
  @spec area(number) :: number
  def area(r), do: r * r * @pi

  @doc "Computes the circumference of a circle"
  @spec circumference(number) :: number
  def circumference(r), do: 2 * r * @pi
end

defmodule StreamFun do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end

  # This is a line with over 80 characters so that it gets picked up by the above code if you were running it through iex or something, you know?

  def lines_lengths!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.with_index()
    |> Enum.map(fn {line, index} -> {index, String.length(line)} end)
  end

  def longest_line_length!(path) do
    File.stream!(path)
    |> Stream.map(&String.length(&1))
    |> Enum.sort(fn x, y -> x > y end)
    |> hd
  end

  def longest_linenum!(path) do
    {{_, _}, linenum} =
      File.stream!(path)
      |> Stream.map(fn l -> {l, String.length(l)} end)
      |> Stream.with_index()
      |> Enum.sort(fn {{_, x}, _}, {{_, y}, _} -> x > y end)
      |> hd

    # NOTE: needs a + 1, since it's zero indexed
    linenum
  end

  def longest_line!(path) do
    {line_text, _} =
      File.stream!(path)
      |> Stream.map(fn x -> {x, String.length(x)} end)
      |> Enum.sort(fn {_, x}, {_, y} -> x > y end)
      |> hd

    line_text
  end

  def word_per_line!(path) do
    File.stream!(path)
    |> Stream.map(fn x -> length(String.split(x)) end)
    |> Stream.with_index()
    |> Enum.map(fn {x, y} -> {y, x} end)
  end
end

defmodule TodoList do
  def new(), do: %{}

  def add_entry(todo_list, date, title) do
    Map.update(todo_list, date, [title], fn titles -> [title | titles] end)
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end
