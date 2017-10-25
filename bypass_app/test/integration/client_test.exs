defmodule ControlRoom.Api.ClientTest do
  use ControlRoom.IntegrationCase

  alias ControlRoom.{Client, Request, Response}
  alias Plug.Conn, as: Conn

  test ".execute() with values returns {:ok, _}", %{bypass: bypass} do
    Bypass.expect bypass, "GET", "/stubout", fn conn ->
      assert "/stubout" == conn.request_path
      assert "GET" == conn.method
      Conn.resp(conn, 200, ~s[{"data": {"ok": "error"}}])
    end
    assert %Response{} = Client.execute(%Request{method: :get, endpoint: "/stubout"})
  end

  test "PATCH .execute() with values returns {:ok, _}", %{bypass: bypass} do
    Bypass.expect bypass, "PUT", "/stubout", fn conn ->
      assert "/stubout" == conn.request_path
      assert "PUT" == conn.method
      Conn.resp(conn, 200, ~s[{"data": {"ok": "error"}}])
    end
    assert %Response{} = Client.execute(%Request{method: :put, endpoint: "/stubout"})
  end

  test ".execute(%Conn{}, %Request{}) should return {:ok, _} | {:error, _}" do
    assert {:error, _} = Client.execute(%{}, struct(Request))
  end

  test ".headers(conn) returns headers" do
    assert %{"Content-Type" => "application/json"} = Client.headers()
    assert %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer foob-bar"
      } = Client.headers(%{access_token: "foob-bar"})
  end

  test "PUT .execute() with values returns {:ok, _}", %{bypass: bypass} do

    Bypass.expect bypass, "PUT", "/stubout/1", fn conn ->
      assert "/stubout/1" == conn.request_path
      assert "PUT" == conn.method
      Conn.resp(conn, 200, ~s[{"data": {"ok": "success"}}])
    end
    mock_token = %{access_token: "value-value", refresh_token: "refresh-refresh"}
    assert %Response{} = Client.execute(mock_token, %Request{method: :put, endpoint: "/stubout/1"})
  end
end
