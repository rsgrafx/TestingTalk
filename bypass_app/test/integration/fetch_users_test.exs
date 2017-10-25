defmodule ControlRoom.FetchUsersIntegrationTest do

  use ControlRoom.IntegrationCase

  alias ControlRoom.{Response, Users}
  alias Plug.Conn, as: Conn
  alias ControlRoom.Conn, as: ControlConn

  @user """
  {"data": {
    "id" : 10,
    "first_name" : "Barnaby",
    "last_name" : "String",
    "email" : "barnaby@string.com",
    "mobile_phone" : "String"
  }}
  """

  describe "Users endpoint" do
    test "/api/v1/user/:id",%{bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/v1/users/10", fn conn ->
        Conn.resp(conn, 200, @user)
      end
      assert %Response{} = Users.get(%ControlConn{access_token: "foobar"}, 10)
    end
  end
end
