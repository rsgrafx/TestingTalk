defmodule ControlRoom.FetchPrequalQuestionsIntegrationTest do

  use ControlRoom.IntegrationCase

  alias ControlRoom.{Response, OrgPrequalQuestions}
  alias Plug.Conn, as: Conn
  alias ControlRoom.Conn, as: ControlConn

  @questions """
  {
    "data": [
      {
        "value_type":"correct_value",
        "value":"No",
        "updated_at":"2017-07-20T15:07:25.816849",
        "title":"Are you a felon?",
        "step":null,
        "placeholder":null,
        "organization_id":1,
        "min":null,
        "max":null,
        "label":null,
        "is_active":true,
        "inserted_at":"2017-07-20T15:07:25.816845",
        "input_type":"radio_bool",
        "input_name":"felon",
        "id":5,
        "description":"Lorem Ipsum.",
        "datatype":"string"
      },
      {
        "value_type":"correct_value",
        "value":"No",
        "updated_at":"2017-07-20T15:07:25.814229",
        "title":"Have you ever been convicted?",
        "step":null,
        "placeholder":null,
        "organization_id":1,
        "min":null,
        "max":null,
        "label":null,
        "is_active":true,
        "inserted_at":"2017-07-20T15:07:25.814223",
        "input_type":"radio_bool",
        "input_name":"convicted",
        "id":4,
        "description":"Lorem Ipsum.",
        "datatype":"string"
      },
      {
        "value_type":"correct_value",
        "value":"No",
        "updated_at":"2017-07-20T15:07:25.811502",
        "title":"Are you in bankruptcy?",
        "step":null,
        "placeholder":null,
        "organization_id":1,
        "min":null,
        "max":null,
        "label":null,
        "is_active":true,
        "inserted_at":"2017-07-20T15:07:25.811497",
        "input_type":"radio_bool",
        "input_name":"bankruptcy",
        "id":3,
        "description":"Lorem Ipsum.",
        "datatype":"string"
      },
      {
        "value_type":"min_ratio",
        "value":"1.3",
        "updated_at":"2017-07-20T15:07:25.808630",
        "title":"What is your income?",
        "step":null,
        "placeholder":null,
        "organization_id":1,
        "min":1,
        "max":10000000,
        "label":"Annual Income",
        "is_active":true,
        "inserted_at":"2017-07-20T15:07:25.808624",
        "input_type":"number",
        "input_name":"annual_income",
        "id":2,
        "description":"Lorem Ipsum.",
        "datatype":"integer"
      },
      {
        "value_type":"min_value",
        "value":"600",
        "updated_at":"2017-07-20T15:07:25.805604",
        "title":"How is your credit?",
        "step":10,
        "placeholder":null,
        "organization_id":1,
        "min":300,
        "max":850,
        "label":"Credit Score",
        "is_active":true,
        "inserted_at":"2017-07-20T15:07:25.805599",
        "input_type":"range",
        "input_name":"credit_score",
        "id":1,
        "description":null,
        "datatype":"integer"
      }
    ]
  }
  """

  describe "Organization Prequalification Questions endpoint" do
    test "/api/v1/organizations/:organization_id/prequalification-questions",%{bypass: bypass} do
      Bypass.expect bypass, "GET", "/api/v1/organizations/1/prequalification-questions", fn conn ->
        Conn.resp(conn, 200, @questions)
      end
      assert %Response{} = OrgPrequalQuestions.get(%ControlConn{access_token: "foobar"}, 1)
    end
  end
end
