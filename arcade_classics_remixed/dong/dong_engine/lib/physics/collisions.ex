defmodule DongEngine.Physics.Collisions do
  @moduledoc """
  Module used to handle collision logic:
    - Ball and Board
    - Ball and Paddle
    - Paddle and Board
  """

  alias DongEngine.GameObjects.Ball
  alias DongEngine.GameObjects.Board
  alias DongEngine.GameObjects.Paddle

  # Detect collisions between a Ball and Board
  # Returns an atom representing which edge of the board the ball has collided with,
  # or :none if no collision detected
  def detect(%Ball{} = ball, %Board{} = board) do
    cond do
      Ball.calculate_edge(ball, :top) <= 0 -> :top
      Ball.calculate_edge(ball, :bottom) >= board.height -> :bottom
      Ball.calculate_edge(ball, :left) <= 0 -> :left
      Ball.calculate_edge(ball, :right) >= board.width -> :right
      true -> :none
    end
  end

  # Detect collision between Ball and Player 1's Paddle
  # Returns true if hit detected
  def detect(%Ball{} = ball, %Paddle{player: 1} = paddle) do
    ball_left_edge_x = Ball.calculate_edge(ball, :left)
    ball_left_edge_y = ball.position.y

    ball_past_paddle? = ball_left_edge_x <= paddle.position.x
    ball_within_paddle_height? =
      ball_left_edge_y >= paddle.position.y && ball_left_edge_y <= paddle.position.y + paddle.height

    ball_past_paddle? && ball_within_paddle_height?
  end

  # Detect collision between Ball and Player 2's Paddle
  # Returns true if hit detected
  def detect(%Ball{} = ball, %Paddle{player: 2} = paddle) do
    ball_right_edge_x = Ball.calculate_edge(ball, :right)
    ball_right_edge_y = ball.position.y

    ball_past_paddle? = ball_right_edge_x >= paddle.position.x
    ball_within_paddle_height? =
      ball_right_edge_y >= paddle.position.y && ball_right_edge_y <= paddle.position.y + paddle.height

    ball_past_paddle? && ball_within_paddle_height?
  end

  # Detect collision between a Paddle and Board
  # Returns true if hit detected
  def detect(%Paddle{} = paddle, %Board{} = board) do
    paddle.position.y <= 0 or paddle.position.y + paddle.height >= board.height
  end

  # Catch-all for invalid types
  def detect(_invalid_object_1, _invalid_object_2) do
    {:error, "invalid objects"}
  end
end
