defmodule Wrazzle.GameComponents.Board do
  @moduledoc false

  alias Wrazzle.GameComponents.BoardSquare

  @board_size 15
  @bonus_tile_coordinate %{
    center: [],
    double_letter: []
  }

  def new do
    @board_size
    |> generate_board(0, 0, 0, %{})
  end

  defp generate_board(board_size, index, row, column, board) do
    cond do
      index == board_size * board_size ->
        board

      column == board_size ->
        generate_board(board_size, index, row + 1, 0, board)

      true ->
        square = BoardSquare.new(index, row, column)
        board = Map.put(board, index, square)
        generate_board(board_size, index + 1, row, column + 1, board)
    end
  end
end
