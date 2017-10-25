defmodule ControlRoom.ProspectPrequalAnswer do

  import Ecto.Changeset

  @type t :: %__MODULE__{
    prospect_id: integer,
    organization_id: integer,
    is_prequalified: boolean,
    answers: [specific_answer]
  }

  @type specific_answer :: %{
    prequal_question_id: integer,
    answer: String.t
  }

  defstruct [
    :prospect_id,
    :organization_id,
    :is_prequalified,
    :answers
  ]

  @data_types %{
    prospect_id: :integer,
    organization_id: :integer,
    is_prequalified: :boolean,
    answers: {:array, :map}
  }

  @doc """
  Changeset to insert into prequal_answers
  """
  def changeset(struct, params \\ %{}) do
    keys = Map.keys(@data_types)
    {struct, @data_types}
    |> cast(params, keys)
    |> cast_embed(:answers, required: true)
  end

  @doc """
  Changeset for any prequalification form. See default_form for details on how to build a form
  """
  def form_changeset(form, params \\ %{}) do
    types = form
    |> Enum.reduce(%{}, fn(item, map) ->
      item = Map.new(item, fn {k, v} -> {String.to_atom(k), v} end)
      case is_atom(item.input_name) do
        true -> Map.put_new(map, item.input_name, item.datatype)
        false -> Map.put_new(map, String.to_atom(item.input_name), String.to_atom(item.datatype))
      end
    end)
    valid_keys = Map.keys(types)

    {%{}, types}
    |> cast(params, valid_keys)
    |> validate_required(valid_keys)
  end

  @doc """
  Changeset for any prequalification form. See default_form for details on how to build a form
  """
  def convert_question_maps(form) do
    Enum.map(form, fn(question) ->
      Map.new(question, fn {k, v} -> {String.to_atom(k), v} end)
    end)
  end

end
