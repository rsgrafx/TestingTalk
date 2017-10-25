defmodule ControlRoom.LoginUserTest do
  use ControlRoom.IntegrationCase

  alias ControlRoom.{Session, Response, Conn}

  describe "Authentication" do

    test "./login_user() return a connection object", %{bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/v1/sessions", fn conn ->
        value = ~s[{"data": {"user_id": "10","access_token":"access-token-success",
        "refresh_token":"refresh-token-success", "expires": 123323}}]
        Plug.Conn.resp(conn, 200, value)
      end

      assert %Response{
        data: %Conn{
          access_token: "access-token-success",
          refresh_token: "refresh-token-success"
        }
      } = Session.login_user(%{"username" => "admin@baz.com", "password" => "bakedBe2ns"})
    end

    test "authenticate(%{mobile_phone: number, password: password})", %{bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/v1/sessions", fn conn ->
        value = ~s[{"data": {"user_id": "10","access_token":"access-token-success",
        "refresh_token":"refresh-token-success", "expires": 123323}}]
        Plug.Conn.resp(conn, 200, value)
      end
      assert %Response{
        data: %Conn{
          access_token: "access-token-success",
          refresh_token: "refresh-token-success"
        }
      } = Session.authenticate(%{"mobile_phone" => "9291113221", "password" => "bakedBe2ns"})
    end
  end
end
