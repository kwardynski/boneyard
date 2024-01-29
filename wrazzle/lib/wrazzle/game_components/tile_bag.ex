defmodule Wrazzle.GameComponents.TileBag do
  @moduledoc false

  alias Wrazzle.GameComponents.Tile

  @tile_settings [
    {"A", 9, 1},
    {"B", 2, 3},
    {"C", 2, 3},
    {"D", 4, 2},
    {"E", 12, 1},
    {"F", 2, 4},
    {"G", 3, 2},
    {"H", 2, 4},
    {"I", 9, 1},
    {"J", 1, 8},
    {"K", 1, 5},
    {"L", 4, 1},
    {"M", 2, 3},
    {"N", 6, 1},
    {"O", 8, 1},
    {"P", 2, 3},
    {"Q", 1, 10},
    {"R", 6, 1},
    {"S", 4, 1},
    {"T", 6, 1},
    {"U", 4, 1},
    {"V", 2, 4},
    {"W", 2, 4},
    {"X", 1, 8},
    {"Y", 2, 4},
    {"Z", 1, 10},
    {"_", 2, 0}
  ]

  @spec new :: [Tile.t()]
  def new do
    Enum.flat_map(@tile_settings, fn {letter, count, value} ->
      Tile.new(letter, value)
      |> List.duplicate(count)
    end)
  end
end