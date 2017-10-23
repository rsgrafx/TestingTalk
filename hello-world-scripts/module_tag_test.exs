defmodule HelloWorld.ModuleTagTest do
  use ExUnit.Case

  @moduletag :foo

  test "trigger module tag raise"
end