defmodule TrickTacToeEngine.CoordinateTest do
  use ExUnit.Case, async: true
  doctest TrickTacToeEngine.Coordinate

  alias TrickTacToeEngine.Coordinate

  describe "new/1" do
    test "returns an :ok tuple if given valid coordinates" do
      coordinate = Coordinate.new(1, 2)
      assert coordinate.row == 1
      assert coordinate.col == 2
    end

    test "returns an :error tuple if row is invalid" do
      assert {:error, :invalid_coordinate} = Coordinate.new(-1, 2)
      assert {:error, :invalid_coordinate} = Coordinate.new(3, 2)
    end

    test "returns an :error tuple if col is invalid" do
      assert {:error, :invalid_coordinate} = Coordinate.new(2, -1)
      assert {:error, :invalid_coordinate} = Coordinate.new(2, 3)
    end
  end

  test "to_index properly converts sub-type coordinate to ind-type coordinate" do
    coord = Coordinate.new(0, 0)
    assert 0 == Coordinate.to_index(coord)

    coord = Coordinate.new(1, 2)
    assert 5 == Coordinate.to_index(coord)
  end

end
