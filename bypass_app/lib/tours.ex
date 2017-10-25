defmodule ControlRoom.Tours do
  @moduledoc """
  House functions that call out to control room api /tours and /tours/{tour_id} endpoints.
  """

  alias ControlRoom.Request
  alias ControlRoom.Response
  alias ControlRoom.ConnError
  alias ControlRoom.Tour
  alias ControlRoom.Client

  def get_scheduled_tours(session) do
    request = struct(Request, method: :get, endpoint: "/api/v1/tours")

    session
    |> Client.execute(request)
    |> return_response()
  end

  def return_response(%{data: data, status: 200}) do
    tours =
      data
      |> Enum.map(fn(t) -> Tour.new(t) end)
      |> Enum.filter(fn
        {:ok, %Tour{}} -> true
        {:error, _} -> false
      end)
      |> Enum.map(fn {:ok, tour} -> tour end)

    struct(Response, data: tours, status: 200)
  end

  def return_response(%{data: [data], status: status}) do
    errors = struct(ConnError, errors: data)
    struct(Response, data: errors, status: status)
  end
end
