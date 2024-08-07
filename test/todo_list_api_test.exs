defmodule TodoListApiTest do
  use ExUnit.Case
  doctest TodoListApi

  test "greets the world" do
    assert TodoListApi.hello() == :world
  end
end
