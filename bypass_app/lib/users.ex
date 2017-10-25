defmodule ControlRoom.Users do
  @moduledoc """
  House functions that call out to control room api /users endpoint.
  """
  alias ControlRoom.{
    Request,
    Response,
    ConnError,
    Client,
    User
  }
  alias Ecto.Changeset

  def return_response(%{data: data, status: 200, meta: meta}) do
    data = Map.new(data, fn {k, v} -> {String.to_atom(k), v} end)
    conn = struct(User, data)
    struct(Response, data: conn, status: 200, description: "User Record", meta: meta)
  end

  def return_response(%{data: body, status: status}) do
    conn_error = struct(ConnError, errors: body)
    struct(Response, data: conn_error, status: status, description: "Authentication Error")
  end

  def get(%{access_token: _atoken} = conn, user_id) when is_binary(user_id) or is_integer(user_id)do
    request = struct(Request, method: :get, endpoint: "/api/v1/users/#{user_id}")
    conn
      |> Client.execute(request)
      |> return_response()
  end

  def create_user(params) do
    request = struct(Request, method: :post, endpoint: "/api/v1/users", request_params: params)
    :conn
    |> Client.execute(request)
    |> return_response()
  end

  def update_user(%{access_token: _at, refresh_token: _rt} = conn, %{"user_id" => user_id} = params) do
    request =
      struct(Request, method: :patch, endpoint: "/api/v1/users/#{user_id}", request_params: params)
    conn
    |> Client.execute(request)
    |> return_response()
  end

  def add_error(changeset, [%{"code" => "duplicate", "description" => desc}]) do
    Changeset.add_error(changeset, :mobile_phone, "phone number #{desc}")
  end

  def add_error(changeset, [%{"code" => code}]) do
    Changeset.add_error(changeset, String.to_atom(code), "#{code} ")
  end

  def create_prospect(tokens, params) do
    request =
      struct(Request, method: :post, request_params: params, endpoint: "/api/v1/prospects")
    tokens
    |> Client.execute(request)
    |> return_response()
  end

end
