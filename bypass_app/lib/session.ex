defmodule ControlRoom.Session do
  @moduledoc """
  Houses functionality for making http request that authenticates the user.
  """
  alias ControlRoom.{
    Client,
    Conn,
    ConnError,
    Request,
    Response
  }

  def verify_phone_number(%{"phone_number" => _number, "mobile_phone_verification_code" => _code} =  params) do
    request = struct(Request, method: :post, request_params: params, endpoint: "/api/v1/mobile-verification")
    request
    |> Client.execute()
    |> return_response()
  end

  def verify_phone_number(_) do
    {:error, :data_malformat}
  end

  def authenticate(%{"mobile_phone" => _, "password" => _} = params) do
    request = struct(Request, method: :post, request_params: params, endpoint: "/api/v1/sessions")
    request
      |> Client.execute()
      |> return_response()
  end

  def login_user(%{"username" => _, "password" => _} = params) do
    Request
    |> struct(method: :post, request_params: params, endpoint: "/api/v1/sessions")
    |> Client.execute()
    |> return_response()
  end

  def return_response(%{data: %{"access_token" => atoken, "refresh_token" => rtoken, "expires" => exp, "user_id" => user_id}, status: status}) do
    conn = struct(Conn, access_token: atoken, refresh_token: rtoken, token_expiration: exp, user_id: user_id)
    struct(Response, data: conn, status: status, description: "Authentication Access Token")
  end

  def return_response(%{data: body, status: status}) do
    conn_error = struct(ConnError, errors: body)
    struct(Response, data: conn_error, status: status, description: "Authentication Error")
  end

end
