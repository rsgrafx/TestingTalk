defmodule ControlRoom.VerifyPhoneNumberTest do
  use ControlRoom.IntegrationCase

  alias Plug.Conn, as: PConn
  alias ControlRoom.{Session, Response, Conn}

  describe "Mobile phone verification" do

    test "./verify_phone_number() returns success refresh token", %{bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/v1/mobile-verification", fn conn ->
        value = ~s[{"data":{"user_id": "10",
        "access_token":"access-token-success",
        "refresh_token":"refresh-token-success", "expires": 123323}}]
        PConn.resp(conn, 200, value)
      end

      assert %Response{
        data: %Conn{
          access_token: "access-token-success",
          refresh_token: "refresh-token-success"
        }
      } = Session.verify_phone_number(%{"phone_number" => "9192311011",
      "mobile_phone_verification_code" => "109121"})
    end

    test "./verify_phone_number() not success refresh token", %{bypass: bypass} do
      Bypass.expect bypass, "POST", "/api/v1/mobile-verification", fn conn ->
        value = ~s|{"errors": [{"code": "expired_token", "description": "description"}]}|
        PConn.resp(conn, 422, value)
      end

      assert %Response{
        data: data
      } = Session.verify_phone_number(%{
        "phone_number" => "9192311011", "mobile_phone_verification_code" => "109100"
        })

      assert is_map(data)
      assert Map.has_key? data, :errors
    end

  end
end
