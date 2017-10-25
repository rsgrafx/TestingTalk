defmodule ControlRoom.User do

  import Ecto.Changeset

  @type t :: %__MODULE__{
    id: integer,
    first_name: String.t,
    last_name: String.t,
    email: String.t,
    mobile_phone: String.t,
    accepted_terms_at: String.t,
    mobile_phone_verification_code: String.t,
    mobile_phone_verified: boolean,
    last_sign_in_at: String.t,
    current_sign_in_at: String.t,
    sign_in_count: integer
  }

  @data_types %{
    id: :integer,
    first_name: :string,
    last_name: :string,
    email: :string,
    mobile_phone: :string,
    mobile_phone_verification_code: :string,
    mobile_phone_verified: :boolean,
    accepted_terms_at: :string,
    last_sign_in_at: :string,
    current_sign_in_at: :string,
    sign_in_count: :integer
  }

  @keys Map.keys(@data_types) -- [:mobile_phone_verified]
  defstruct List.flatten([@keys|[mobile_phone_verified: false]])

  def changeset(struct, params \\ %{}) do
    {struct, @data_types}
    |> cast(params, @keys)
  end

  def update_changeset(struct, params \\ %{}) do
    chg =
      {struct, @data_types}
      |> cast(params, @keys)
    %{chg | action: :update}
  end

  @doc """
  Non-schema changeset used to validate that terms were accepted (boolean). Not using
  User.changeset due to fact that we are not storing terms_accepted, instead storing terms_accepted_at
  """
  def registration_changeset(params) do
    types = %{accepted_terms: :boolean, mobile_phone: :string}
    {%{}, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:accepted_terms, :mobile_phone])
    |> sanitize_phone_number()
    |> validate_format(:mobile_phone, ~r/^[2-9][0-9]{9}/)
  end

  def verification_code_changeset(params \\ %{}) do
    castable = %{
      mobile_phone_verification_code: :string,
      mobile_phone: :string,
      mobile_phone_verified: :boolean
    }
    {%{}, castable}
    |> cast(params, Map.keys(castable))
    |> validate_required([:mobile_phone_verification_code])
  end

  @doc """
  Cleans, sanitizes, and reformats the user inputed mobile phone number
  """
  def sanitize_phone_number(params) do
    dirty_mobile_phone = get_field(params, :mobile_phone)

    case is_nil(dirty_mobile_phone) do
      true -> clean_mobile_phone = dirty_mobile_phone
      false ->
        clean_mobile_phone = dirty_mobile_phone
        |> String.replace(~r/[^0-9]/, "") # Strips out all non-numeric characters
        |> check_phone_length_and_leading_one()
    end
    change(params, %{mobile_phone: clean_mobile_phone})
  end

  @doc """
  Checks if the user has inputted an 11 digit phone with a leading 1, or a 10 digit phone with no leading 1
  """
  def check_phone_length_and_leading_one(mobile_phone) do
    if Regex.run(~r/^1\d{10}$/, mobile_phone) do
      mobile_phone
      |> String.replace(~r/^1/, "")
    else
      mobile_phone
    end
  end

end
