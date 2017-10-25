defmodule ControlRoom.Tour do
  alias ControlRoom.Unit

  @type t :: %__MODULE__{
    id: integer,
    status: String.t,
    start_time: Timex.DateTime,
    end_time: Timex.DateTime,
    unit: Unit.t,
  }

  defstruct [
    :id,
    :status,
    :start_time,
    :end_time,
    :unit,
  ]

  def canceled_status, do: "canceled"

  def new(%{
    "id" => id,
    "status" => status,
    "start_time" => start_time,
    "end_time" => end_time,
    "unit" => unit,
  }) do
    start_parse_result = Timex.parse(start_time, "{ISO:Extended}")
    end_parse_result = Timex.parse(end_time, "{ISO:Extended}")

    case {start_parse_result, end_parse_result} do
      {{:ok, start_time}, {:ok, end_time}} ->
        unit =
          unit
          |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
          |> (fn(map) -> struct(Unit, map) end).()

        {
          :ok,
          %__MODULE__{
            id: id,
            status: status,
            start_time: start_time,
            end_time: end_time,
            unit: unit,
          }
        }

      _ -> # start or end time couldn't be parsed; don't return a partial timeslot
        {:error, :invalid_time_format}
    end
  end
end
