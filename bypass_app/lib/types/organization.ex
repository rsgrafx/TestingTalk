defmodule ControlRoom.Organization do
  @type t :: %__MODULE__{
    name: String.t,
    url: String.t,
    logo_url: String.t,
    marketing_url: String.t,
    support_phone: String.t,
    terms_conditions: String.t,
  }

  defstruct [
    :name,
    :url,
    :logo_url,
    :marketing_url,
    :support_phone,
    :terms_conditions,
  ]
end
