if !System.get_env("RUNNING_ON_DIFFERENT_ENV") do
  Code.load_file("hello_world.exs", __DIR__)
  Code.load_file("./it.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure exclude: :pending, trace: true

defmodule HelloWorldTest do
  use ExUnit.Case
  use Customize.It

  @moduletag false

  setup do
    # Contexts are passed down
    {:ok, parent: :PARENT_DATA }
  end

  test "says hello with no name" do
    assert HelloWorld.hello() == "Hello, World!"
    IO.inspect(self(), label: "what is self --> \n")
  end

  test "assert does not do an exact comparison", context do
    IO.inspect(context, label: "\n")
    assert context[:foo] == true
  end

  it "says hello sample name" do
    assert HelloWorld.hello("Alice") == "Hello, Alice!"
  end

  it "should fail hello sample name" do
    refute HelloWorld.hello("Alice") == "Hello, JackAss!"
  end

  it "should not curse me out." do
    refute HelloWorld.hello("Alice") == "Hello, JackAss!"
  end

  describe "Grouped Tests" do

    setup context do
      IO.inspect(
        context,
        label: "This is the context result"
      )
      # Contexts are passed down
      refute Map.has_key? context, :child

      {:ok, child: %{foo: :bar}}
    end

    test "display context", context do

      assert Map.has_key? context, :parent
      assert Map.has_key? context, :child

      IO.inspect(
        context,
        label: "This is the context result"
      )
    end
  end

  @tag :pending # Module Tag
  test "says hello other sample name" do
    assert HelloWorld.hello("Bob") == "Hello, Bob!"
  end

  test "un used match", context do
    IO.inspect("UNUSED LABEL: \n")
    assert context = context
  end

  # tests are converted to functions.
  IO.inspect Module.definitions_in(HelloWorldTest, :def)
end
