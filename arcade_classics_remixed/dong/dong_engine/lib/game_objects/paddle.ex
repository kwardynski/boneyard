defmodule DongEngine.GameObjects.Paddle do
  @moduledoc """
  Representation of the paddle(s) used in play

  Actions:
    - move -> move the paddle up or down based on previous position and speed

  Note:
    Y direction/speed is "flipped" from "normal" since (0,0) is at the top-left of the game
    board and increases downwards
  """

  alias __MODULE__
  alias DongEngine.GameObjects.Board
  alias DongEngine.Physics.Vector

  @enforce_keys [:position, :speed, :height, :player]
  defstruct [:position, :speed, :height, :player]

  @doc """
  Returns a signed tuple
  :ok if
    - height is numeric
    - height is less than board height
    - speed is numeric and greater than zero
    - player number in [1,2]
  :error if any above checks do not pass
  """
  def new(%Board{} = board, height, speed, player) do
    with(
      :ok <- validate_numeric("paddle height", height),
      :ok <- validate_positive("paddle height", height),
      :ok <- validate_paddle_height(height, board.height),
      :ok <- validate_numeric("paddle speed", speed),
      :ok <- validate_positive("paddle speed", speed),
      :ok <- validate_player(player)
    ) do
      starting_x = calculate_starting_x(player, board.width)
      starting_y = calculate_starting_y(height, board.height)
      {
        :ok,
        %Paddle{
          position: %Vector{x: starting_x, y: starting_y},
          speed: speed,
          height: height,
          player: player
        }
      }
    else
      {:error, _msg} = error -> error
    end
  end

  def move(%Paddle{} = paddle, :up) do
    new_position =
      paddle.position
      |> Map.put(:y, paddle.position.y - paddle.speed)
    Map.put(paddle, :position, new_position)
  end

  def move(%Paddle{} = paddle, :down) do
    new_position =
      paddle.position
      |> Map.put(:y, paddle.position.y + paddle.speed)
    Map.put(paddle, :position, new_position)
  end

  defp calculate_starting_x(1, _board_width), do: 0
  defp calculate_starting_x(2, board_width), do: board_width

  defp calculate_starting_y(paddle_height, board_height), do: (board_height - paddle_height)/2

  defp validate_numeric(type, value) do
    case is_number(value) do
      true -> :ok
      false -> {:error, "#{type} must be a numeric value"}
    end
  end

  defp validate_positive(type, value) do
    case value > 0 do
      true -> :ok
      false -> {:error, "#{type} must be a positive value"}
    end
  end

  defp validate_paddle_height(paddle_height, board_height) do
    case paddle_height < board_height do
      true -> :ok
      false -> {:error, "paddle height cannot exceed board height"}
    end
  end

  defp validate_player(player) do
    case player in [1,2] do
      true -> :ok
      false -> {:error, "player number can only be 1 or 2"}
    end
  end
end
