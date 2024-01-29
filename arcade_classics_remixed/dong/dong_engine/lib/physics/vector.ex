defmodule DongEngine.Physics.Vector do
  @moduledoc """
  Simple struct representation of a 2-D vector.
  Nothing fancy to see here
  """

  alias __MODULE__
  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  def new(x, y) do
    {:ok, %Vector{x: x, y: y}}
  end

end
