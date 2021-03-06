Code.load_file "module_tagged.ex", __DIR__
Code.load_file "../hello-world-scripts/it.exs", __DIR__

ExUnit.start
ExUnit.configure exclude: :hated, trace: true

defmodule ModuleTaggedTest do
  use ExUnit.Case
  use Customize.It

  @moduletag name: :orion

  it "should not be ignored", context do
    assert context[:name] == :orion
  end

  it "should ignored"

  it "should not be ignored but is...", context do
    assert context[:name] == :orion
    assert 1+2 == 2
  end

end
