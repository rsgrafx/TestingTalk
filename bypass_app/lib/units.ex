defmodule ControlRoom.Units do
  @moduledoc """
  Housed functions that call out to Control Room Api for Units resource
  """
  alias ControlRoom.{
    Request,
    Response,
    Client,
    Unit,
    Conn,
    ConnError
  }

  def return_response(%{data: data, status: 200}) do
    data = Map.new(data, fn {k, v} -> {String.to_atom(k), v} end)
    unit = struct(Unit, data)
    struct(Response, data: unit, status: 200, description: "Unit record")
  end

  def return_response(%{data: [data], status: status}) do
    errors = struct(ConnError, errors: data)
    struct(Response, data: errors, status: status, description: "Error fetching unit record")
  end

  def get_unit_with_referral_code(nil), do: struct(ConnError, errors: %{code: "no_referral_code_sent"})
  def get_unit_with_referral_code(ref_code) do
    request = struct(Request, method: :get, endpoint: "/api/v1/unit-referral/#{ref_code}")
    :conn
    |> Client.execute(request)
    |> return_response()
  end

  def create_tour_timeslot(%Conn{} = conn, params) do
    request = struct(Request, method: :post, endpoint: "/api/v1/tours", request_params: params)
    conn
    |> Client.execute(request)
    |> return_response()
  end
end
