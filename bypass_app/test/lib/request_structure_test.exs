defmodule ControlRoom.RequestStructureTest do
  use ExUnit.Case

  alias ControlRoom.Request

  test "Request struct should have Http method attr" do
    assert %{method: _} = struct(Request)
  end

  test "Request struct should have request_params attr" do
    assert %{request_params: _} = struct(Request)
  end

  test "Request struct should have an endpoint attr" do
    assert %{endpoint: _} = struct(Request)
  end
end
