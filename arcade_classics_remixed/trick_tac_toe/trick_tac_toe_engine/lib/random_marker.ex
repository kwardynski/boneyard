defmodule TrickTacToeEngine.RandomMarker do
  @moduledoc """
  Module responsible for the "random" generation of markers for the board
  """

  @markers [:x, :o]

  @doc """
  Returns either :x or :o with equal probability
  """
  def generate() do
    @markers
    |> Enum.random()
  end

  @doc """
  Returns either :x or :o, with a 65% preference for the other value
  I.E. if :x was given, you have a 35% chance of getting :x, and a 65%
  chance of getting :o
  """
  def get(:x) do
    case Enum.random(1..100) < 65 do
      true -> {:ok, :o}
      false -> {:ok, :x}
    end
  end

  def get(:o) do
    case Enum.random(1..100) < 65 do
      true -> {:ok, :x}
      false -> {:ok, :o}
    end
  end

  def get(_), do: generate()

end
