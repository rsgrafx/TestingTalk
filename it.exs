defmodule Customize.It do
  @moduledoc """
   Modify with It
  """

  @reserved [:case, :file, :line, :test, :async, :registered, :describe, :type, :it]

  @doc false
  defmacro __using__(opts) do
    unless Process.whereis(ExUnit.Server) do
      raise "cannot use ExUnit.Case without starting the ExUnit application, " <>
            "please call ExUnit.start() or explicitly start the :ex_unit app"
    end

    quote do
      async = !!unquote(opts)[:async]

      unless Module.get_attribute(__MODULE__, :ex_unit_tests) do
        Enum.each [:ex_unit_tests, :tag, :describetag, :moduletag, :ex_unit_registered],
          &Module.register_attribute(__MODULE__, &1, accumulate: true)

      end

      import ExUnit.Callbacks
      import ExUnit.Assertions
      import Customize.It, only: [it: 1, it: 2, it: 3]
      import ExUnit.DocTest
    end
  end

  @doc """
  Defines a test with a string.

  Provides a convenient macro that allows a test to be
  defined with a string. This macro automatically inserts
  the atom `:ok` as the last line of the test. That said,
  a passing test always returns `:ok`, but, more importantly,
  it forces Elixir to not tail call optimize the test and
  therefore avoids hiding lines from the backtrace.

  ## Examples

      it "true is equal to true" do
        assert true == true
      end

  """
  defmacro it(message, var \\ quote(do: _), contents) do
    contents =
      case contents do
        [do: block] ->
          quote do
            unquote(block)
            :ok
          end
        _ ->
          quote do
            try(unquote(contents))
            :ok
          end
      end

    var      = Macro.escape(var)
    contents = Macro.escape(contents, unquote: true)

    quote bind_quoted: [var: var, contents: contents, message: message] do
      name = ExUnit.Case.register_test(__ENV__, :test, message, [])
      def unquote(name)(unquote(var)), do: unquote(contents)
    end
  end

  @doc """
  Defines a not implemented test with a string.

  Provides a convenient macro that allows a test to be defined
  with a string, but not yet implemented. The resulting test will
  always fail and print "Not implemented" error message. The
  resulting test case is also tagged with `:not_implemented`.

  ## Examples

      it "this will be a test in future"

  """
  defmacro it(message) do
    quote bind_quoted: binding() do
      name = ExUnit.Case.register_test(__ENV__, :test, message, [:not_implemented])
      def unquote(name)(_), do: flunk("Not implemented")
    end
  end

  @doc """
  Describes tests together.

  Every describe block receives a name which is used as prefix for
  upcoming tests. Inside a block, `ExUnit.Callbacks.setup/1` may be
  invoked and it will define a setup callback to run only for the
  current block. The describe name is also added as a tag, allowing
  developers to run tests for specific blocks.

  ## Examples

      defmodule StringTest do
        use ExUnit.Case, async: true

        describe "String.capitalize/1" do
          it "first grapheme is in uppercase" do
            assert String.capitalize("hello") == "Hello"
          end

          it "converts remaining graphemes to lowercase" do
            assert String.capitalize("HELLO") == "Hello"
          end
        end
      end

  When using Mix, you can run all tests in a describe block as:

      mix test --only describe:"String.capitalize/1"

  Note describe blocks cannot be nested. Instead of relying on hierarchy
  for composition, developers should build on top of named setups. For
  example:

      defmodule UserManagementTest do
        use ExUnit.Case, async: true

        describe "when user is logged in and is an admin" do
          setup [:log_user_in, :set_type_to_admin]

          test ...
        end

        describe "when user is logged in and is a manager" do
          setup [:log_user_in, :set_type_to_manager]

          test ...
        end

        defp log_user_in(context) do
          # ...
        end
      end

  By forbidding hierarchies in favor of named setups, it is straight-forward
  for the developer to glance at each describe block and know exactly the
  setup steps involved.
  """

  defmacro __before_compile__(_) do
    quote do
      def __ex_unit__(:case) do
        %ExUnit.TestCase{name: __MODULE__, tests: @ex_unit_tests}
      end
    end
  end

  @doc false
  def __after_compile__(%{module: module}, _) do
    if Module.get_attribute(module, :ex_unit_async) do
      ExUnit.Server.add_async_case(module)
    else
      ExUnit.Server.add_sync_case(module)
    end
  end

  @doc """
  Registers a function to run as part of this case.

  This is used by 3rd party projects, like QuickCheck, to
  implement macros like `property/3` that works like `test`
  but instead defines a property. See `test/3` implementation
  for an example of invoking this function.

  The test type will be converted to a string and pluralized for
  display. You can use `ExUnit.plural_rule/2` to set a custom
  pluralization.
  """
  def register_test(%{module: mod, file: file, line: line}, type, name, tags) do
    moduletag = Module.get_attribute(mod, :moduletag)

    unless moduletag do
      raise "cannot define #{type}. Please make sure you have invoked " <>
            "\"use ExUnit.Case\" in the current module"
    end

    registered_attributes = Module.get_attribute(mod, :ex_unit_registered)
    registered = Map.new(registered_attributes, &{&1, Module.get_attribute(mod, &1)})

    tag = Module.delete_attribute(mod, :tag)
    async = Module.get_attribute(mod, :ex_unit_async)

    {name, describe, describetag} =
      if describe = Module.get_attribute(mod, :ex_unit_describe) do
        {:"#{type} #{describe} #{name}", describe, Module.get_attribute(mod, :describetag)}
      else
        {:"#{type} #{name}", nil, []}
      end

    if Module.defines?(mod, {name, 1}) do
      raise ExUnit.DuplicateTestError, ~s("#{name}" is already defined in #{inspect mod})
    end

    tags =
      (tags ++ tag ++ describetag ++ moduletag)
      |> normalize_tags
      |> validate_tags
      |> Map.merge(%{line: line, file: file, registered: registered,
                     async: async, describe: describe, type: type})

    test = %ExUnit.Test{name: name, case: mod, tags: tags}
    Module.put_attribute(mod, :ex_unit_tests, test)

    Enum.each registered_attributes, fn(attribute) ->
      Module.delete_attribute(mod, attribute)
    end

    name
  end

  @doc """
  Registers a new attribute to be used during `ExUnit.Case` tests.

  The attribute values will be available as a key/value pair in
  `context.registered`. The key/value pairs will be cleared
  after each `ExUnit.Case.test/3` similar to `@tag`.

  `Module.register_attribute/3` is used to register the attribute,
  this function takes the same options.

  ## Examples

      defmodule MyTest do
        use ExUnit.Case
        ExUnit.Case.register_attribute __ENV__, :foobar

        @foobar hello: "world"
        test "using custom test attribute", context do
          assert context.registered.hello == "world"
        end
      end
  """
  def register_attribute(env, name, opts \\ [])

  def register_attribute(%{module: module}, name, opts) do
    register_attribute(module, name, opts)
  end

  def register_attribute(mod, name, opts) when is_atom(mod) and is_atom(name) and is_list(opts) do
    Module.register_attribute(mod, name, opts)
    Module.put_attribute(mod, :ex_unit_registered, name)
  end

  defp validate_tags(tags) do
    for tag <- @reserved,
        Map.has_key?(tags, tag) do
      raise "cannot set tag #{inspect tag} because it is reserved by ExUnit"
    end

    unless is_atom(tags[:type]),
      do: raise "value for tag `:type` must be an atom"

    tags
  end

  defp normalize_tags(tags) do
    Enum.reduce Enum.reverse(tags), %{}, fn
      tag, acc when is_atom(tag) -> Map.put(acc, tag, true)
      tag, acc when is_list(tag) -> tag |> Enum.into(acc)
    end
  end
end
