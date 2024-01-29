defmodule Wrazzle.GameComponents.BoardSquare do
  @moduledoc false

  defstruct [
    :index,
    :row,
    :column,
    :tile,
    :bonus
  ]

  @type bonus_types() :: :center | :double_letter | :triple_letter | :double_word | :triple_word

  @type t() :: %__MODULE__{
          index: integer(),
          row: integer(),
          column: integer(),
          tile: Tile.t() | nil,
          bonus: bonus_types() | nil
        }

  @spec new(integer(), integer(), integer(), atom()) :: BoardSquare.t()
  def new(index, row, column, bonus \\ nil) do
    %__MODULE__{
      index: index,
      row: row,
      column: column,
      tile: nil,
      bonus: bonus
    }
  end

  @spec add_bonus(BoardSquare.t(), atom()) :: BoardSquare.t()
  def add_bonus(%__MODULE__{} = board_square, bonus), do: %{board_square | bonus: bonus}
end
