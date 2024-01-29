defmodule HelloWordTest do
  use ExUnit.Case
  doctest HelloWord

  test "greets the world" do
    assert HelloWord.hello() == :world
  end
end
