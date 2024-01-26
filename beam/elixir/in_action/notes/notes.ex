defmodule Fraction do
  defstruct a: nil, b: nil

  def new(a, 0) do
    # SOMETHING!
  end

  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  def value(%Fraction{a: a, b: 0}) do
    # SOMETHING!
  end

  def value(%Fraction{a: a, b: b}) do
    a / b
  end

  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(a1 * b2 + a2 * b1, b2 * b1)
  end
end

# Structs and complex type assertions look like so:
# one_half = %Fraction{ a: 1, b: 2}
# faux_fract = %{ a: 1, b: 2 }
# This works:
# %Fraction{} = one_half
# This doesn't:
# %Fraction{} = faux_fract
# one_quarter = %Fraction{ a: 1, b: 4 } = %Fraction{one_half | b: 4}
