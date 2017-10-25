defmodule ControlRoom.GetUnitWithReferralCodeTest do

  use ControlRoom.IntegrationCase

  alias ControlRoom.{Response, Units, Unit}
  alias Plug.Conn, as: Conn

  @unit """
  {"data":{
    "status":"Vacant",
    "street_address_1" : "foo baz ave",
    "street_address_2" : "baz bar ave",
    "city" : "Pleasantville",
    "state" : "AZ",
    "zip" : "93802",
    "timezone" : "America/Phoenix",
    "marketing_name" : "Colonial Home",
    "image_url" : "http://placeit.net/examplelink.png"
  }}
  """

  describe "Users endpoint" do
    test "/api/v1/unit-referral/:referral_code",%{bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/v1/unit-referral/110d94ed-abe6-4e00-95bc-7d8a72885578", fn conn ->
        Conn.resp(conn, 200, @unit)
      end
      assert %Response{data: %Unit{} = unit} = Units.get_unit_with_referral_code("110d94ed-abe6-4e00-95bc-7d8a72885578")
      assert unit.street_address_1 == "foo baz ave"
      assert unit.status == "Vacant"
    end
  end
end
