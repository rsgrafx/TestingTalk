defmodule ControlRoom.ToursEndointTest do

  use ControlRoom.IntegrationCase

  alias ControlRoom.{Response, Units, Unit}
  alias Plug.Conn, as: Conn

  @success """
  {
    "data": {
        "unit": {
            "zip": "85020",
            "unit_code": "A6E01A-181",
            "street_address_2": "F181",
            "street_address_1": "181 Williams Dr",
            "group": {
                "marketing_name": "Vista Del Sol"
            },
            "floor": "3",
            "city": "Apache Junction",
            "building": "F"
        },
        "status": "scheduled",
        "start_time": "2017-08-08T21:30:00Z",
        "id": 16,
        "end_time": "2017-08-08T22:00:00Z"
    }
  }
  """

  @error """
  {
    "errors": [
        {
            "description": "This unit is not available to tour",
            "code": "unit_not_tourable"
        }
    ]
  }
  """

  describe "Users endpoint" do
    test "CREATE /api/v1/user", %{bypass: bypass} do

      Bypass.expect bypass, "POST", "/api/v1/tours", fn conn ->
        Conn.resp(conn, 200, @success)
      end

      assert %Response{data: %Unit{}} =
        Units.create_tour_timeslot(%ControlRoom.Conn{access_token: "foobar", refresh_token: "refresh-token"},
          %{"unit_id" => 481, "accepted_terms_at" => "2017-07-18 17:32:33.446180Z"})
    end
  end
end
