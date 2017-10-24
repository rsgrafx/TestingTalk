defmodule GenserverTesting do
  @moduledoc """
  Documentation for GenserverTesting.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GenserverTesting.hello
      :world

  """
  def hello do
    :world
  end

  defmodule PasswordLock do
    use GenServer

    def start(password) do
      GenServer.start_link(__MODULE__, password, [])
    end

    def unlock(server_pid, password) do
      GenServer.call(server_pid, {:unlock, password})
    end


    def reset(server_pid, {current_password, new_password}) do
      if current_password(server_pid) == current_password do
        GenServer.cast(server_pid, {:reset_password, new_password})
        {:ok, :reset}
      else
        {:error, :incorrect_password}
      end
    end

    def handle_call({:unlock, password}, _, state) do
      if state == password do
        {:reply, true, state}
        else
        {:reply, false, state}
      end
    end

    def handle_call(:current, _, state) do
      {:reply, state, state}
    end

    def handle_cast({:reset_password, new_password}, state) do
      {:noreply, new_password}
    end

    defp current_password(pid) do
      GenServer.call(pid, :current)
    end
  end
end
