defmodule SmexTest do
  use ExUnit.Case
  doctest Smex

  test "greets the world" do
    assert Smex.hello() == :world
  end
end
