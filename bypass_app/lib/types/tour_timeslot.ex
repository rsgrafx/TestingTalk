defmodule ControlRoom.TourTimeslot do
  alias Timex.Timezone

  @type t :: %__MODULE__{
    start_time: Timex.DateTime,
    end_time: Timex.DateTime,
    available: boolean,
  }

  defstruct [
    start_time: nil,
    end_time: nil,
    available: false
  ]

  def new(%{
    "start" => start_time,
    "end" => end_time,
    "available" => available
  }) do
    start_parse_result = Timex.parse(start_time, "{ISO:Extended}")
    end_parse_result = Timex.parse(end_time, "{ISO:Extended}")

    case {start_parse_result, end_parse_result} do
      {{:ok, start_time}, {:ok, end_time}} ->
        %__MODULE__{
          start_time: start_time,
          end_time: end_time,
          available: available,
        }

      _ -> # start or end time couldn't be parsed; don't return a partial timeslot
        nil
    end
  end

  def with_timezone(%__MODULE__{} = timeslot, timezone) when is_binary(timezone) do
    %__MODULE__{
      start_time: Timezone.convert(timeslot.start_time, timezone),
      end_time: Timezone.convert(timeslot.end_time, timezone),
      available: timeslot.available,
    }
  end
end
