defmodule ControlRoom.Client.Server do
  @moduledoc """
  This module houses functionality that Maintain Access Token.
  """
  alias ControlRoom.{Client, Conn}

  use GenServer

  # Public API into this Server
  def start_link(conn, request, opts \\ []) do
    GenServer.start_link(__MODULE__, %{conn: conn, request: request}, opts)
  end

  def shutdown(pid) do
    GenServer.stop(pid, :normal)
  end

  def call({:ok, pid}) do
    make_request(pid)
  end

  def status(pid) do
    GenServer.call(pid, :current_status)
  end

  def make_request(pid) do
    GenServer.call(pid, :make_request)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:make_request, _, state) do
    state.conn
    |> Client.call_http_request(state.request)
    |> case do
      %{data: :refresh_token, status: 401} ->
        auth_refresh =
          state.conn
          |> Client.refresh_token()
          |> Client.return_response()
          # create new connection
        params =
          auth_refresh.data
          |> new_conn_params()

        new_conn =
          Conn |> struct(params)

        req_response =
          new_conn
          |> Client.call_http_request(state.request)

        response =
          %{req_response | meta: auth_refresh}
        {:reply, response, %{state | conn: new_conn}}
      response ->
        {:reply, response, state}
    end
  end

  def handle_call(:current_status, _,  state) do
    {:reply, state, state}
  end

  def handle_info(:status, state) do
    {:noreply, state}
  end

  defp new_conn_params(refresh_response) do
    %{
      "access_token" => access,
      "refresh_token" => refresh,
      "expires" => time,
      "user_id" => user_id
    } = refresh_response
    [
      access_token: access,
      refresh_token: refresh,
      token_expiration: time,
      user_id: user_id
    ]
  end
end
