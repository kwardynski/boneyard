defmodule TrickTacToeEngine.Coordinate do
  @moduledoc """
  Simple representation of a coordinate within the board
  Coordinates are 0-based
  Assuming board is a square
  """

  alias __MODULE__

  @enforce_keys [:row, :col]
  @board_size 2

  defstruct [:row, :col]

  @doc """
  Creates a new coordinate struct, ensuring the guess coordinates are within the
  bounds of the game board
  """
  def new(row, col) when row in (0..@board_size) and col in (0..@board_size) do
    %Coordinate{row: row, col: col}
  end

  def new(_row, _col) do
    {:error, :invalid_coordinate}
  end

  @doc """
  Converts a coordinate to index based on board size
  ## Examples
    iex> coord= TrickTacToeEngine.Coordinate.new(2, 1)
    iex>  TrickTacToeEngine.Coordinate.to_index(coord)
    7
  """
  def to_index(%Coordinate{row: row, col: col}) do
    row_step = row*(@board_size+1)
    col_step = col
    row_step + col_step
  end

  @doc """
  Converts an index back to a coordinate based on board size
  ## Examples
    iex> TrickTacToeEngine.Coordinate.to_coord(7)
    %TrickTacToeEngine.Coordinate{row: 2, col: 1}

    iex> TrickTacToeEngine.Coordinate.to_coord(10)
    {:error, :invalid_coordinate}
  """
  def to_coord(index) do
    row = floor(index/(@board_size+1))
    col = index - row*(@board_size+1)
    new(row, col)
  end
end
