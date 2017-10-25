defmodule ControlRoom.Client do
  require Tesla
  @moduledoc """
    Handles the execution -> makes request on the wire.
  """
  alias ControlRoom.{Client.Server, Request, Response}
  @base_endpoint Application.get_env(:control_room, :endpoint)

  def headers(conn \\ %{}) do
    defaults = %{"Content-Type" => "application/json"}
    case Map.fetch(conn, :access_token) do
      {:ok, val} -> Map.merge(defaults, %{"Authorization" => "Bearer #{val}"})
      _error -> defaults
    end
  end

  def client(%{access_token: token} = _conn) do
    Tesla.build_client([
      {Tesla.Middleware.Headers, %{"Authorization" => "Bearer #{token}"}},
      {Tesla.Middleware.Headers, %{"Content-Type" => "application/json"}}
    ])
  end

  def client(:conn) do
    Tesla.build_client([
      {Tesla.Middleware.Headers, %{"Content-Type" => "application/json"}}
    ])
  end

  def refresh_token(%{refresh_token: refresh_token}) do
      endpoint = full_url("/api/v1/tokens")
      :conn
      |> client
      |> Tesla.post(endpoint, "", headers: %{"Authorization-X-Refresh" => refresh_token})
  end

  def call_http_request(conn \\ :conn, %Request{method: method, request_params: params, endpoint: endpoint}) do
    endpoint = full_url(endpoint)
    case method do
      :post  -> conn |> post(endpoint, params) |> return_response(conn)
      :put   -> conn |> put(endpoint, params)  |> return_response(conn)
      :patch -> conn |> patch(endpoint, params) |> return_response(conn)
      :get   -> conn |> get(endpoint) |> return_response(conn)
      _ -> {:error, :bad_request}
    end
  end

  def execute(conn \\ :conn, request) do
    {:ok, pid} = Server.start_link(conn, request)
    response = Server.make_request(pid)
    Server.shutdown(pid)
    response
  end

  def return_response(tesla_body, conn \\ %{})

  def return_response(%{status: 401}, conn) when is_map(conn) do
    struct(Response, data: :refresh_token, status: 401)
  end

  def return_response(%{body: body, headers: headers, status: status}, _conn) when is_binary(body) do
    if Mix.env in [:dev, :test] do
      require Logger
      Logger.info("\nRESPONSE FROM CONTROL ROOM: \n\n#{body}")
    end
    parsed = body
      |> Poison.decode!
    %{body: parsed, headers: headers, status: status}
      |> return_response()
  end

  def return_response(%{body: %{"data" => parsed}, status: status}, _conn) do
    struct(Response, data: parsed, status: status, description: "Response from Control Room")
  end

  def return_response(%{body: %{"errors" => parsed}, status: status}, _conn) do
    struct(Response, data: parsed, status: status, description: "Error Response from Control Room")
  end

  def post(:conn, endpoint, params) do
    params = Poison.encode!(params)
    Tesla.post(endpoint, params, headers: headers())
  end

  def post(%{access_token: _token} = conn, endpoint, params) do
    params = Poison.encode!(params)
    conn
    |> client()
    |> Tesla.post(endpoint, params)
  end

  def put(:conn, endpoint, params) do
    params = Poison.encode!(params)
    :conn
    |> client()
    |> Tesla.put(endpoint, params)
  end

  def put(%{access_token: _token} = conn, endpoint, params) do
    params = Poison.encode!(params)
    conn
    |> client()
    |> Tesla.put(endpoint, params)
  end

  def patch(%{access_token: _token} = conn, endpoint, params) do
    params = Poison.encode!(params)
    conn
    |> client()
    |> Tesla.patch(endpoint, params)
  end

  def patch(_conn, endpoint, params) do
    params = Poison.encode!(params)
    :conn
    |> client()
    |> Tesla.patch(endpoint, params)
  end

  def get(:conn, endpoint) do
    :conn
    |> client()
    |> Tesla.get(endpoint)
  end

  def get(%{access_token: _token} = conn, endpoint) do
    conn
    |> client()
    |> Tesla.get(endpoint)
  end

  defp full_url(nil) do
    @base_endpoint
  end

  defp full_url(endpoint) do
    "#{@base_endpoint}#{endpoint}"
  end

end
