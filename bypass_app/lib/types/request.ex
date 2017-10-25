defmodule ControlRoom.Request do

  @type t :: %__MODULE__{
    method: atom,
    request_params: map,
    endpoint: String.t
  }

  defstruct [:method, :endpoint, request_params: %{}]

end
