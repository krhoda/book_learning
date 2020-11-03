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

  def area(r), do: r*r*@pi
  def circumference(r), do: 2*r*@pi
end
