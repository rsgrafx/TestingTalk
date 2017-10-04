if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("hello_world.exs", __DIR__)
  Code.load_file("../it.exs", __DIR__)
end

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule HelloWorldTest do
  use ExUnit.Case
  use Customize.It

  setup do
    # Contexts are passed down
    {:ok, parent: :PARENT_DATA }
  end

  test "says hello with no name" do
    assert HelloWorld.hello() == "Hello, World!"
  end

  it "says hello sample name" do
    assert HelloWorld.hello("Alice") == "Hello, Alice!"
  end

  it "should fail hello sample name" do
    refute HelloWorld.hello("Alice") == "Hello, JackAss!"
  end

  it "should not cuss me out." do
    refute HelloWorld.hello("Alice") == "Hello, JackAss!"
  end

  describe "Grouped Tests \n" do

    setup context do
      IO.inspect(
        context,
        label: "This is the context result \n"
      )
      # Contexts are passed down
      refute Map.has_key? context, :child

      {:ok, child: %{foo: :bar}}
    end

    test "\t display context \n", context do

      assert Map.has_key? context, :parent
      assert Map.has_key? context, :child

      IO.inspect(
        context,
        label: "This is the context result \n"
      )
    end
  end

  @tag :pending # Module Tag
  test "says hello other sample name" do
    assert HelloWorld.hello("Bob") == "Hello, Bob!"
  end

end
