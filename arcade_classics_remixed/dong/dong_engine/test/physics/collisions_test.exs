defmodule DongEngine.Physics.CollisionsTest do
  use ExUnit.Case, async: true
  doctest DongEngine.Physics.Collisions

  alias DongEngine.GameObjects.Ball
  alias DongEngine.GameObjects.Board
  alias DongEngine.GameObjects.Paddle
  alias DongEngine.Physics.Collisions
  alias DongEngine.Physics.Vector


  describe "detect(%Ball{}, %Board{})" do
    setup do
      %{
        board: %Board{height: 100, width: 100},
        ball_radius: 12,
        ball_velocity: %Vector{x: 0, y: 0}
      }
    end

    test "detects collision at top edge", fixture do
      position = %Vector{x: 50, y: 12}
      ball = %Ball{position: position, velocity: fixture.ball_velocity, radius: fixture.ball_radius}
      assert :top == Collisions.detect(ball, fixture.board)
    end

    test "detects collision at bottom edge", fixture do
      position = %Vector{x: 50, y: 88}
      ball = %Ball{position: position, velocity: fixture.ball_velocity, radius: fixture.ball_radius}
      assert :bottom == Collisions.detect(ball, fixture.board)
    end

    test "detects collision at left edge", fixture do
      position = %Vector{x: 12, y: 50}
      ball = %Ball{position: position, velocity: fixture.ball_velocity, radius: fixture.ball_radius}
      assert :left == Collisions.detect(ball, fixture.board)
    end

    test "detects collision at right edge", fixture do
      position = %Vector{x: 88, y: 50}
      ball = %Ball{position: position, velocity: fixture.ball_velocity, radius: fixture.ball_radius}
      assert :right == Collisions.detect(ball, fixture.board)
    end

    test "returns :none for no collision", fixture do
      position = %Vector{x: 50, y: 50}
      ball = %Ball{position: position, velocity: fixture.ball_velocity, radius: fixture.ball_radius}
      assert :none == Collisions.detect(ball, fixture.board)
    end
  end

  describe "detect(%Ball{}, %Paddle{})" do

    test "detects collision with Player 1's paddle" do
      paddle = %Paddle{
        position: %Vector{x: 0, y: 45},
        speed: 10,
        height: 10,
        player: 1
      }
      ball = %Ball{
        position: %Vector{x: 9, y: 46},
        velocity: %Vector{x: 0, y: 0},
        radius: 10
      }
      assert Collisions.detect(ball, paddle)
    end

    test "detects collision with Player 2's paddle" do
      paddle = %Paddle{
        position: %Vector{x: 100, y: 45},
        speed: 10,
        height: 10,
        player: 2
      }
      ball = %Ball{
        position: %Vector{x: 92, y: 46},
        velocity: %Vector{x: 0, y: 0},
        radius: 10
      }
      assert Collisions.detect(ball, paddle)
    end

    test "detects no collision" do
      paddle = %Paddle{
        position: %Vector{x: 0, y: 45},
        speed: 10,
        height: 10,
        player: 1
      }

      [ {0, 10}, {50, 50} ]
      |> Enum.each(fn({x, y}) ->
        ball = %Ball{
          position: %Vector{x: x, y: y},
          velocity: %Vector{x: 0, y: 0},
          radius: 10
        }

        refute Collisions.detect(ball, paddle)
      end)
    end
  end

  describe "detect(%Paddle{}, %Board{})" do
    setup do
      %{
        board: %Board{height: 100, width: 100},
        paddle: %Paddle{
          position: %Vector{x: 0, y: 0},
          speed: 0,
          height: 10,
          player: 1
        }
      }
    end

    test "returns true if top paddle edge above top of board", fixture do
      assert Collisions.detect(fixture.paddle, fixture.board)
    end

    test "returns true if bottom paddle edge below bottom of board", fixture do
      new_position = %Vector{x: 0, y: 90}
      paddle = Map.put(fixture.paddle, :position, new_position)
      assert Collisions.detect(paddle, fixture.board)
    end

    test "returns false if paddle within board bounds", fixture do
      new_position = %Vector{x: 0, y: 50}
      paddle = Map.put(fixture.paddle, :position, new_position)
      refute Collisions.detect(paddle, fixture.board)
    end
  end

  test "detect/2 returns  error tuple for invalid objects" do
    {:error, msg} = Collisions.detect(12, 12)
    assert msg == "invalid objects"
  end
end
