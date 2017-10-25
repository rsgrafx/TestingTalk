defmodule ControlRoom.OrgPrequalQuestions do
  @moduledoc """
  Functions that call out to control room api /units/{unit_id}/tour-timeslots endpoint.
  """

  alias ControlRoom.{
    Request,
    Response,
    ConnError,
    Client,
    OrgPrequalQuestion
  }
  # alias Ecto.Changeset

  def return_response(%{data: data, status: 200}) do
    struct(Response, data: data, status: 200, description: "Organization Prequalification Records")
  end

  # def return_response(%{data: body, status: status}) do
  #   conn_error = struct(ConnError, errors: body)
  #   struct(Response, data: conn_error, status: status, description: "Authentication Error")
  # end

  def get(token, organization_id) when is_binary(organization_id) or is_integer(organization_id) do
    request = struct(Request, method: :get, endpoint: "/api/v1/organizations/#{organization_id}/prequalification-questions")
    token
    |> Client.execute(request)
    |> return_response()
  end
end
