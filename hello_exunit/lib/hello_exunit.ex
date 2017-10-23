defmodule HelloExunit do

  require Logger
  @moduledoc """
  Documentation for HelloExunit.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HelloExunit.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  This is a parallel map

    iex> HelloExunit.pmap [10, 20, 30], &(&1 * 2)
    [20, 40, 60]

  """
  def pmap(values, func)
  when is_list(values) and is_function(func),
    do: (
      Logger.info "begin processing:"
      Enum.map(values, func)
    )

  def async_pmap(collection, func) do
    caller = self()
    collection
    |> Enum.map(fn(x) ->
      spawn_link(fn ->
        # This does not return anything.
        send caller, {self, func.(x)}
        send caller, {self, :ok}
      end)
    end)
    |> Enum.map(fn task_pid ->
      (receive do
        {^task_pid, result} -> result
      end)
    end)
  end


  @doc """
  Doubles the items in a list

    iex> HelloExunit.double([1, 3, 6])
    [2, 6, 12]

  """
  def double(values),
    do: pmap(values, &(&1 * 2))


  def async_double(values),
    do: async_pmap(values, &(&1 * 2))

end
