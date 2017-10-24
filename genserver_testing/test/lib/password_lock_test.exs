defmodule GenserverTesting.PasswordLockTest do
  use ExUnit.Case
  alias GenserverTesting.PasswordLock

  describe "PasswordLock module" do
    setup do
      {:ok, pid} =PasswordLock.start("abc123")
      %{pid: pid}
    end
    test "starts a process", context do
      assert is_pid(context[:pid])
    end

    test "unlocks password", %{pid: pid} do
      # {:ok, pid} = PasswordLock.start("abc123")
      assert PasswordLock.unlock(pid, "abc123")
    end

    test "resets password" do
      {:ok, pid} = PasswordLock.start("JENNA JAMESON")

      assert {:ok, _} = PasswordLock.reset(pid, {"JENNA JAMESON", "foobar"})

      assert PasswordLock.unlock(pid, "foobar")
    end
  end
end