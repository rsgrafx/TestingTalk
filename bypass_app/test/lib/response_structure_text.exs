defmodule ControlRoom.ResponseStructureTest do
  use ExUnit.Case

  alias ControlRoom.Response

  test "Response struct should have data attr" do
    assert %{data: _} = struct(Response)
  end

  test "Response struct should have status attr" do
    assert %{status: _} = struct(Response)
  end

  test "Response struct should have an data_description attr" do
    assert %{description: _} = struct(Response)
  end

end
