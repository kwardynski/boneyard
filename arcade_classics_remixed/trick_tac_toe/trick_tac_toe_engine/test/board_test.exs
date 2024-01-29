defmodule TrickTacToeEngine.BoardTest do
  use ExUnit.Case, async: true

  alias TrickTacToeEngine.Board

  describe "check_if_full/1" do
    test "returns true if board is full" do
      board =
        1..8
        |> Enum.to_list
        |> Enum.into(%{}, fn(k) -> {k, :x} end)

      assert Board.check_if_full(board)
    end

    test "returns false if board is not full" do
      board =
        1..5
        |> Enum.to_list
        |> Enum.into(%{}, fn(k) -> {k, :x} end)

      refute Board.check_if_full(board)
    end
  end

  describe "check_for_win" do
    test "returns true for vertical line" do
      board = %{2 => :x, 5 => :x, 8 => :x}
      assert Board.check_for_win(board)
    end

    test "returns true for horizontal line" do
      board = %{3 => :x, 4 => :x, 5 => :x}
      assert Board.check_for_win(board)
    end

    test "returns true for diagonal line" do
      board = %{2 => :x, 4 => :x, 6 => :x}
      assert Board.check_for_win(board)
    end

    test "returns false if no win possible" do
      board = %{0 => :x, 1 => :o, 2 => :o, 3 => :o, 4 => :nil, 5 => :x, 6 => :nil, 7 => :o, 8 => :x}
      refute Board.check_for_win(board)
    end
  end
end
