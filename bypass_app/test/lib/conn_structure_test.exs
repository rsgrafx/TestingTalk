defmodule ControlRoom.ConnStructureTest do
  use ExUnit.Case

  alias ControlRoom.Conn

  test "Conn struct should have data attr" do
    assert %{access_token: _} = struct(Conn)
  end

  test "Conn struct should have status attr" do
    assert %{refresh_token: _} = struct(Conn)
  end

  test "Conn struct should have an data_description attr" do
    assert %{token_expiration: _} = struct(Conn)
  end

  test "Conn struct should have an user_id attr" do
    assert %{user_id: _} = struct(Conn)
  end
end
