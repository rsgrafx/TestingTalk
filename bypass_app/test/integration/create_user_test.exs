defmodule ControlRoom.CreateUserIntegrationTest do

  use ControlRoom.IntegrationCase

  alias ControlRoom.{Response, Users, User}
  alias Plug.Conn, as: Conn

  @user """
  {"data": {
    "id" : 10,
    "first_name" : "Barnaby",
    "last_name" : "String",
    "email" : "barnaby@string.com",
    "mobile_phone" : "9192210001",
    "accepted_terms_at": "2017-07-18 17:32:33.446180Z",
    "last_sign_at": "2017-07-18 17:32:33.446180Z"
  }}
  """

  describe "Users endpoint" do
    test "CREATE /api/v1/user", %{bypass: bypass} do

      Bypass.expect bypass, "POST", "/api/v1/users", fn conn ->
        Conn.resp(conn, 200, @user)
      end

      assert %Response{data: %User{mobile_phone: "9192210001"}} =
        Users.create_user(%{"mobile_phone" => "9192210001", "accepted_terms_at" => "2017-07-18 17:32:33.446180Z"})
    end
  end
end
