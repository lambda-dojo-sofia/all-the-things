defmodule InvertedTest do
  use ExUnit.Case
  doctest Inverted

  test "greets the world" do
    assert Inverted.hello() == :world
  end
end
