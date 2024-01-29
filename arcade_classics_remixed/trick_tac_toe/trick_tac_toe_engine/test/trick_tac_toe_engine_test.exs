defmodule TrickTacToeEngineTest do
  use ExUnit.Case
  doctest TrickTacToeEngine

  test "greets the world" do
    assert TrickTacToeEngine.hello() == :world
  end
end
