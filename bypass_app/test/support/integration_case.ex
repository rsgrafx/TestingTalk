defmodule ControlRoom.IntegrationCase do
  @moduledoc """
    Router tests - base template ensure routes the same.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case, async: true
      # The default endpoint for testing
      @endpoint Application.get_env(:control_room, :endpoint)
    end
  end

  setup do
    bypass = Bypass.open(port: 4022)
    {:ok, bypass: bypass}
  end
end
