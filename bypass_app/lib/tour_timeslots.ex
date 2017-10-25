defmodule ControlRoom.TourTimeslots do
  @moduledoc """
  House functions that call out to control room api /organizations/{organization_id}/prequalification-questions endpoint.
  """

  alias ControlRoom.Unit
  alias ControlRoom.Request
  alias ControlRoom.Response
  alias ControlRoom.ConnError
  alias ControlRoom.TourTimeslot
  alias ControlRoom.Client

  def get_tour_timeslots_for_unit(session, %Unit{} = unit) do
    request = struct(Request, method: :get, endpoint: "/api/v1/units/#{unit.id}/tour-timeslots")

    session
    |> Client.execute(request)
    |> return_response()
  end

  def return_response(%{data: data, status: 200}) do
    timeslots =
      data
      |> Enum.map(fn(t) -> TourTimeslot.new(t) end)

    struct(Response, data: timeslots, status: 200)
  end

  def return_response(%{data: [data], status: status}) do
    errors = struct(ConnError, errors: data)
    struct(Response, data: errors, status: status)
  end
end
