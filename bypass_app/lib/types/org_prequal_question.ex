defmodule ControlRoom.OrgPrequalQuestion do

  import Ecto.Changeset

  @type t :: %__MODULE__{
    value_type: String.t,
    value: String.t,
    title: String.t,
    step: integer,
    placeholder: String.t,
    organization_id: integer,
    min: integer,
    max: integer,
    label: String.t,
    is_active: boolean,
    input_type: String.t,
    input_name: String.t,
    id: integer,
    description: String.t,
    datatype: String.t
  }

  defstruct [
    :value_type,
    :value,
    :title,
    :step,
    :placeholder,
    :organization_id,
    :min,
    :max,
    :label,
    :is_active,
    :input_type,
    :input_name,
    :id,
    :description,
    :datatype
  ]

  # @data_types %{
  #   value_type: :string,
  #   value: :string,
  #   title: :string,
  #   step: :integer,
  #   placeholder: :string,
  #   organization_id: :integer,
  #   min: :integer,
  #   max: :integer,
  #   label: :string,
  #   is_active: :boolean,
  #   input_type: :string,
  #   input_name: :string,
  #   id: :integer,
  #   description: :string,
  #   datatype: :string
  # }

  # def changeset(struct, params \\ %{}) do
  #   {struct, @data_types}
  #   |> cast(params, @keys)
  # end
end
