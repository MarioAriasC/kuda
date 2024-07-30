defmodule KudaTest do
  use ExUnit.Case
  doctest Kuda

  test "greets the world" do
    assert Kuda.hello() == :world
  end
end
