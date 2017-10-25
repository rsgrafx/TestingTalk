defmodule ControlRoom.Response do

  @type t :: %__MODULE__{
    data: map,
    description: String.t,
    status: String.t | integer,
    meta: map
  }

  defstruct [:data, :description, :status, :meta]
end
