defmodule HelloExunitTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  doctest HelloExunit

  describe "Block A" do

    test "greets the world" do
      assert HelloExunit.hello() == :world
    end

    test "all context is inherited", context do
      # IO.inspect(context, label: "CONTEXT\n")
      assert is_map(context)
      assert HelloExunit.hello() == :world
    end
  end

  describe "PMap" do

    test "pmap maps as list" do
      assert [2, 4, 6] == HelloExunit.pmap [1, 2, 3], &(&1 * 2)
    end

    test ".double double items" do
      assert [2, 4, 6] == HelloExunit.double [1, 2, 3]
    end

    test "pmap logs output" do
      assert capture_log(fn ->
        HelloExunit.double([1, 2, 3])
      end) =~ "begin processing:"

      refute capture_log(fn ->
        HelloExunit.double([1, 2, 3])
      end) =~ "yada yada yada:"
    end

    test ".async_map" do
      assert HelloExunit.async_double([1, 3, 9])

      assert_receive({pid1, :ok})
      assert_receive({pid2, :ok})
      assert_receive({pid3, :ok})

      refute pid1 == pid2
      refute pid1 == pid3
      refute pid2 == pid3
    end
  end

end
