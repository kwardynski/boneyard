defmodule DongEngine.GameObjects.PaddleTest do
  use ExUnit.Case, async: true
  doctest DongEngine.GameObjects.Paddle

  alias DongEngine.GameObjects.Board
  alias DongEngine.GameObjects.Paddle
  alias DongEngine.Physics.Vector

  describe "new/4" do
    setup do
      %{
        board: %Board{height: 100, width: 100},
        invalid_numeric_values: [0, -10],
        invalid_player_values: [0, 3, "test", :test]
      }
    end

    test "returns {:ok, %Paddle{}} with valid inputs", fixture do
      {:ok, paddle} = Paddle.new(fixture.board, 20, 10, 1)
      assert paddle.height == 20
      assert paddle.position.x == 0
      assert paddle.position.y == 40
    end

    test "returns error tuple if height not numeric", fixture do
      {:error, msg} = Paddle.new(fixture.board, :not_numeric, 10, 1)
      assert msg == "paddle height must be a numeric value"
    end

    test "returns error tuple if height is zero or negative", fixture do
      fixture.invalid_numeric_values
      |> Enum.each(fn(val) ->
        {:error, msg} = Paddle.new(fixture.board, val, 10, 1)
        assert msg == "paddle height must be a positive value"
      end)
    end

    test "returns error tuple if paddle height greater than board height", fixture do
      {:error, msg} = Paddle.new(fixture.board, 101, 10, 1)
      assert msg == "paddle height cannot exceed board height"
    end

    test "returns error tuple if speed not numeric", fixture do
      {:error, msg} = Paddle.new(fixture.board, 20, :not_numeric, 1)
      assert msg == "paddle speed must be a numeric value"
    end

    test "returns error tuple if paddle speed is zero or negative", fixture do
      fixture.invalid_numeric_values
      |> Enum.each(fn(val) ->
        {:error, msg} = Paddle.new(fixture.board, 10, val, 1)
        assert msg == "paddle speed must be a positive value"
      end)
    end

    test "returns error tuple if player value invalid", fixture do
      fixture.invalid_player_values
      |> Enum.each(fn(val) ->
        {:error, msg} = Paddle.new(fixture.board, 10, 20, val)
        assert msg == "player number can only be 1 or 2"
      end)
    end
  end

  describe "move/2" do
    setup do
      %{
        paddle: %Paddle{
          position: %Vector{x: 0, y: 20},
          speed: 10,
          height: 5,
          player: 1
        }
      }
    end

    test "successfully moves a paddle upwards", fixture do
      moved_paddle = Paddle.move(fixture.paddle, :up)
      assert moved_paddle.position.y == 10
    end

    test "successfully moves a paddle downwards", fixture do
      moved_paddle = Paddle.move(fixture.paddle, :down)
      assert moved_paddle.position.y == 30
    end

    test "function clause error if first argument not a %Paddle{} struct" do
      assert_raise(FunctionClauseError, fn ->
        Paddle.move(:invalid, :up)
      end)
    end

    test "function clause error if second argument not a valid direction", fixture do
      assert_raise(FunctionClauseError, fn ->
        Paddle.move(fixture.paddle, :left)
      end)
    end
  end
end
