defmodule DongEngine.GameObjects.BoardTest do
  use ExUnit.Case, async: true
  doctest DongEngine.GameObjects.Board

  alias DongEngine.GameObjects.Board

  describe "new/2" do
    setup do
      %{
        valid_integer: 12,
        valid_float: 4.20,
        invalid_numerics: [-12, -4.2, 0],
        non_numeric_values: [:not, "numbers", {:at, "all"}]
      }
    end

    test "returns {:ok, %Board{}} with valid inputs", fixture do
      {:ok, %Board{} = board} = Board.new(fixture.valid_integer, fixture.valid_float)
      assert board.height == fixture.valid_integer
      assert board.width == fixture.valid_float
    end

    test "returns error tuple if height not numeric", fixture do
      fixture.non_numeric_values
      |> Enum.each(fn(val) ->
        {:error, msg} = Board.new(val, fixture.valid_integer)
        assert msg == "height must be a numeric value"
      end)
    end

    test "returns error tuple if width not numeric", fixture do
      fixture.non_numeric_values
      |> Enum.each(fn(val) ->
        {:error, msg} = Board.new(fixture.valid_integer, val)
        assert msg == "width must be a numeric value"
      end)
    end

    test "returns error tuple if height zero or negative", fixture do
      fixture.invalid_numerics
      |> Enum.each(fn(val) ->
        {:error, msg} = Board.new(val, fixture.valid_integer)
        assert msg == "height must be a positive value"
      end)
    end

    test "returns error tuple if width zero or negative", fixture do
      fixture.invalid_numerics
      |> Enum.each(fn(val) ->
        {:error, msg} = Board.new(fixture.valid_integer, val)
        assert msg == "width must be a positive value"
      end)
    end
  end
end
