defmodule TrickTacToeEngine.Board do
  @moduledoc """
  Simple representation of a board
  Markers are stored in a map with the INDEX of the coordinate as the key
  """

  alias TrickTacToeEngine.Coordinate
  alias TrickTacToeEngine.RandomMarker

  @total_tiles 8

  def new() do
    %{}
  end

  @doc """
  Processes a hit against the board with a coordinate.
  If the coordinate has been previously guessed, returns the board
  If the coordinate is new, assigns a new marker to the coordinate and returns the
  updated board.
  """
  def handle_hit(board, %Coordinate{} = guess, marker) do
    guess_ind = Coordinate.to_index(guess)
    case Map.get(board, guess_ind) do
      nil -> {:ok, Map.put(board, guess_ind, RandomMarker.get(marker))}
      _ -> {:already_guessed, board}
    end
  end

  @doc """
  Checks whether the board is full - i.e. game is "complete"
  """
  def check_if_full(board) do
    1..@total_tiles
    |> Enum.to_list()
    |> check_tile(board)
  end

  defp check_tile([], _board), do: true
  defp check_tile([tile | tiles], board) do
    case Map.get(board, tile) do
      nil -> false
      _ -> check_tile(tiles, board)
    end
  end


  @doc """
  Checks whether whether 3 of the same markers are all in line
  Checks all 8 possible lines through the board until a win condition is found
  """
  def check_for_win(board) do
    [
      {0, 0, 0, 1},
      {1, 0, 0, 1},
      {2, 0, 0, 1},
      {0, 0, 1, 0},
      {0, 1, 1, 0},
      {0, 2, 1, 0},
      {0, 0, 1, 1},
      {0, 2, 1, -1},
    ]
    |> do_check_for_win(board, false)
  end

  defp do_check_for_win(_patterns, _board, true), do: true
  defp do_check_for_win([], _board, line_complete?), do: line_complete?
  defp do_check_for_win([{row, col, row_step, col_step} | patterns], board, _line_complete?) do
    line_complete? = check_line(board, row, col, row_step, col_step)
    do_check_for_win(patterns, board, line_complete?)
  end

  defp check_line(board, row, col, row_step, col_step) do
    line_markers =
      0..2
      |> Enum.map(fn(step) -> {row + step*row_step, col + step*col_step} end)
      |> Enum.map(fn({row, col}) -> Coordinate.new(row, col) end)
      |> Enum.map(fn(coord) -> Coordinate.to_index(coord) end)
      |> Enum.map(fn(index) -> Map.get(board, index) end)

    cond do
      Enum.any?(line_markers, &is_nil/1) -> false
      Enum.uniq(line_markers) == [:x] -> true
      Enum.uniq(line_markers) == [:o] -> true
      true -> false
    end
  end
end
