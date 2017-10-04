Code.load_file "module_tagged.ex", __DIR__
Code.load_file "../it.exs", __DIR__

ExUnit.start
ExUnit.configure exclude: :hated, trace: true

defmodule ModuleTaggedTest do
  use ExUnit.Case
  use Customize.It

  it "should not be ignored", context do
    assert context
  end

  @moduletag :hated
  it "should ignored"

  it "should not be ignored but is...", context do
    assert 1+2 == 2
  end

end
