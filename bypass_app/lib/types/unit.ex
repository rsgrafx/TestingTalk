defmodule ControlRoom.Unit do

  @type t :: %__MODULE__{
    city: String.t,
    id: integer,
    image_url: String.t,
    marketing_name: String.t,
    monthly_rent: integer,
    organization_id: integer,
    referral_code: String.t,
    state: String.t,
    status: String.t,
    street_address_1: String.t,
    street_address_2: String.t,
    timezone: String.t,
    zip: String.t,
  }

  defstruct [
    :city,
    :id,
    :image_url,
    :marketing_name,
    :monthly_rent,
    :organization_id,
    :referral_code,
    :state,
    :status,
    :street_address_1,
    :street_address_2,
    :timezone,
    :zip,
  ]
end
