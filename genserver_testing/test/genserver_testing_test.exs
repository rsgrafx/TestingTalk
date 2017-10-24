defmodule GenserverTestingTest do
  use ExUnit.Case
  doctest GenserverTesting

  test "greets the world" do
    assert GenserverTesting.hello() == :world
  end
end
