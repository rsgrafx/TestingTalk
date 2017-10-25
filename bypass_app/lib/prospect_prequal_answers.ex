defmodule ControlRoom.ProspectPrequalAnswers do
  @moduledoc """
  House functions that call out to control room api /prospects/{prospect_id}/prequalification-answers endpoint.
  """

  import Ecto.Changeset
  import Plug.Conn

  alias ControlRoom.{
    Request,
    Response,
    ConnError,
    Client,
    OrgPrequalQuestion,
    OrgPrequalQuestions,
    ProspectPrequalAnswer,
    ProspectPrequalAnswers
  }
  alias Resident.TokenHelper

  def return_response(%{data: data, status: 200}) do
    data = Map.new(data, fn {k, v} -> {String.to_atom(k), v} end)
    conn = struct(ProspectPrequalAnswer, data)
    struct(Response, data: conn, status: 200, description: "Prospect Prequalification Records")
  end

  def return_response(%{data: body, status: status}) do
    conn_error = struct(ConnError, errors: body)
    struct(Response, data: conn_error, status: status, description: "Authentication Error")
  end

  def post(token, payload) do
    request = struct(Request, method: :post, endpoint: "/api/v1/prospects/#{payload.prospect_id}/prequalification-answers", request_params: payload)
    token
    |> Client.execute(request)
    |> return_response()
  end

  @doc """
  Check if prequalification questions valid, if they are insert prequal_answers record,
  Else return error changeset
  """
  def validate_and_insert(conn, form, params \\ %{}) do
    form_changeset = ProspectPrequalAnswer.form_changeset(form, params)

    with true <- form_changeset.valid?,
      prequal_answers <- form_to_prequal_answer_changeset(conn, form, form_changeset),
      true <- user_is_prequalified(prequal_answers, form, conn.assigns.unit.monthly_rent),
      %{data: user_prequal_answers} <- save_prequal_answers(conn, prequal_answers) do
      # {:ok, user_prequal_answers} <- save_prequal_answers(conn, prequal_answers) do
        {:ok, user_prequal_answers}
    else
      _ -> {:error, %{form_changeset | action: :update}}
    end
  end

  @doc """
  Take a prequal form changeset and transform into a prequal_answers changeset for db insertion
  """
  def form_to_prequal_answer_changeset(conn, form, form_changeset) do
    form_params = apply_changes(form_changeset)

    answers = form
    |> Enum.map(fn item ->
      item = Map.new(item, fn {k, v} -> {String.to_atom(k), v} end)
      answer = Map.get(form_params, String.to_atom(item.input_name))
      case is_number(answer) do
        true ->
          %{prequal_question_id: Integer.to_string(item.id), answer: Integer.to_string(answer)}
        false ->
          %{prequal_question_id: Integer.to_string(item.id), answer: answer}
      end
    end)

    %{prospect_id: get_session(conn, :prospect_id), answers: answers}
  end

  @doc """
  Get the prospect's pre-qualification answers and compare them to the
  minimum requirements as set by the organization for the unit
  """
  def user_is_prequalified(%{answers: prequal_answers}, form, monthly_rent) do
    pre_qual_status = prequal_answers
    |> Enum.map(fn(answer) -> String.to_integer(answer.prequal_question_id) end) # get question_ids from the users answers
    |> org_questions_parse_answered(form) # get the org's questions by the question_ids answered by the user
    |> merge_answers_and_questions(prequal_answers, monthly_rent) # send prospect's answers and org's questions to validation

    is_nil(Enum.find(pre_qual_status, fn(meets_requirement) -> meets_requirement == false end))
  end

  @doc """
  Get the org prequal questions, and parse out only those that have been answered by the prospect
  """
  def org_questions_parse_answered(answered_question_ids, form) do
    form
  end

  # @doc """
  # Here we map over each question and locate it's corresponding answer to determine which type
  # of question it is: `min_value`, `correct_value`, or `min_ratio`; sending it off to the
  # appropriate function to determine if the answer meets requirements
  # """
  def merge_answers_and_questions(questions, answers, monthly_rent) do
    Enum.map(questions, fn(question) ->
      adj_question = Map.new(question, fn {k, v} -> {String.to_atom(k), v} end)
      case adj_question.value_type do
        "min_value" ->
          adj_question.id
          |> Integer.to_string()
          |> get_corresponding_question_answer(answers)
          |> verify_min_value(adj_question)
        "correct_value" ->
          adj_question.id
          |> Integer.to_string()
          |> get_corresponding_question_answer(answers)
          |> verify_correct_value(adj_question)
        "min_ratio" ->
          adj_question.id
          |> Integer.to_string()
          |> get_corresponding_question_answer(answers)
          |> verify_min_ratio(adj_question, monthly_rent)
      end
    end)
  end

  # @doc """
  # The function that hunts for the corresponding user answer to a specific org question
  # """
  def get_corresponding_question_answer(question_id, answers),
    do: Enum.find(answers, fn(answer) -> answer.prequal_question_id == question_id end)

  # @doc """
  # Convert the answers to integers and then check if the prospect's answer is greater than or equal
  # to the organization's minimum value
  # """
  def verify_min_value(%{answer: answer}, %{value: value}),
    do: String.to_integer(answer) >= String.to_integer(value)

  # @doc """
  # This function is used to check basic radio-button answers. Example, the zorg asks `Are you a felon?`
  # and the user answers `No`. The org then requires this answer to be `No`.
  # """
  # def verify_correct_value(%ProspectPrequalAnswer{answer: answer}, %OrgPrequalQuestion{value: value}),
  def verify_correct_value(%{answer: answer}, %{value: value}),
    do: answer == value

  # @doc """
  # Here we check that the prospect's income meets the appropriate ratio to the monthly rent
  # """
  def verify_min_ratio(%{answer: answer}, %{value: value}, monthly_rent),
    do: (String.to_integer(answer) / (monthly_rent * 12)) >= String.to_float(value)

  @doc """
  Prequalification questions were valid, insert prequal_answers record
  """
  def save_prequal_answers(conn, answers) do
    payload = answers
    |> Map.put(:organization_id, "#{get_session(conn, :organization_id)}")
    |> Map.put(:is_prequalified, "true")

    tokens = TokenHelper.setup_tokens(conn)
    %{data: user_prequal_answers} = post(tokens, payload)
  end
end
