defmodule ControlRoom.ConnErrorStructureTest do
  use ExUnit.Case, async: true

  alias ControlRoom.ConnError

  test "it should have error attr" do
    assert %{errors: _} = struct(ConnError)
  end

end
