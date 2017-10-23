ExUnit.start()

defmodule LoadedCodeTest do
  use ExUnit.Case
  setup context do
    if file = context[:loaded_file] do
      Code.load_file(file, __DIR__)
      |> IO.inspect(label: "BYTE CODE of Module \n")
    end
  end

  @tag loaded_file: "./module_tagged.ex"
  test "loaded code" do
    result =
      ModuleTagged.hello("Jennifer")

    assert match? result, "Hello Jennifer"
  end

end