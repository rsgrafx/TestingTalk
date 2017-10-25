defmodule ControlRoom.Conn do

  @type t :: %__MODULE__{
    access_token: String.t,
    refresh_token: String.t,
    token_expiration: String.t | integer,
    user_id: integer
  }

  defstruct [:access_token, :refresh_token, :token_expiration, :user_id]
end
