defmodule DongEngine.GameObjects.Board do
  @moduledoc """
  Representation of the board / playing area
  The board dimesions could be represented using the DongEngine.Physics.Vector module,
  however that seems overly complex for the sake of composition. Furthermore, having
  the :height and :width attributes explicitly laid out makes the board representation
  more idiomatic

  Note:
    Y direction is "flipped" form "normal" since (0,0) is at the top-left of the game
    board and increases downwards
  """

  alias __MODULE__

  @enforce_keys [:height, :width]
  defstruct [:height, :width]

  @doc """
  Returns a signed tuple
  :ok if height and width are both numeric and positive values
  :error if either argument are non-numeric or negative values
  """
  def new(height, width) do
    with(
      :ok <- validate_numeric("height", height),
      :ok <- validate_numeric("width", width),
      :ok <- validate_positive("height", height),
      :ok <- validate_positive("width", width)
    ) do
      {:ok, %Board{height: height, width: width}}
    else
      {:error, _msg} = error -> error
    end
  end

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

end
