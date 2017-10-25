defmodule ControlRoom.ConnError do

  @type error_list :: List.t
  @type t :: %__MODULE__{
    errors: error_list
  }
  defstruct [errors: []]

end
