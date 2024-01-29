defmodule DongEngine.GameObjects.Ball do
  @moduledoc """
  Representation of the ball used in play

  Actions:
    - move -> calculate the ball's new position based on previous position and velocity
    - bounce -> if a collision is detected, return a new randomized direction based on valid
      angle and max/min velocity

  Note:
    Y direction/velocity is "flipped" from "normal" since (0,0) is at the top-left of the game
    board and increases downwards
  """

  alias __MODULE__
  alias DongEngine.Physics.Vector


  @enforce_keys [:position, :velocity, :radius]
  defstruct [:position, :velocity, :radius]

  def new(%Vector{} = position, %Vector{} = velocity, radius) do
    {
      :ok,
      %Ball{
        position: position,
        velocity: velocity,
        radius: radius
      }
    }
  end

  def move(%Ball{} = ball) do
    new_x = ball.position.x + ball.velocity.x
    new_y = ball.position.y + ball.velocity.y
    Map.put(ball, :position, %Vector{x: new_x, y: new_y})
  end

  def bounce(%Ball{} = ball, min_velocity, max_velocity, collision) do
    new_velocity = random_float(min_velocity, max_velocity)
    new_direction = randomize_direction_with_constraint(collision)
    x_component = calculate_x_component(new_direction, new_velocity)
    y_component = calculate_y_component(new_direction, new_velocity)
    Map.put(ball, :velocity, %Vector{x: x_component, y: y_component})
  end

  def calculate_edge(%Ball{} = ball, :top), do: ball.position.y - ball.radius
  def calculate_edge(%Ball{} = ball, :bottom), do: ball.position.y + ball.radius
  def calculate_edge(%Ball{} = ball, :left), do: ball.position.x - ball.radius
  def calculate_edge(%Ball{} = ball, :right), do: ball.position.x + ball.radius
  def calculate_edge(_ball, _edge), do: {:error, "Invalid Edge"}

  def randomize_direction_with_constraint(:top), do: random_float(:math.pi, 2*:math.pi)
  def randomize_direction_with_constraint(:bottom), do: random_float(0, :math.pi)
  def randomize_direction_with_constraint(:right), do: random_float(0.5*:math.pi, 1.5*:math.pi)
  def randomize_direction_with_constraint(:left) do
    angle = random_float(1.5*:math.pi, 2.5*:math.pi)
    case angle > 2*:math.pi do
      true -> angle - 2*:math.pi
      false -> angle
    end
  end

  defp random_float(min, max) do
    min + :rand.uniform() * (max-min)
  end

  def calculate_x_component(direction, velocity) do
    {sign, theta} = cond do
      direction <= :math.pi/2 -> {1, direction}
      direction <= :math.pi -> {-1, :math.pi - direction}
      direction <= :math.pi*1.5 -> {-1, direction - :math.pi}
      true -> {1, 2*:math.pi - direction}
    end
    sign*velocity*:math.cos(theta)
  end

  def calculate_y_component(direction, velocity) do
    {sign, theta} = cond do
      direction <= :math.pi/2 -> {1, direction}
      direction <= :math.pi -> {1, :math.pi - direction}
      direction <= :math.pi*1.5 -> {-1, direction - :math.pi}
      true -> {-1, 2*:math.pi - direction}
    end
    -sign*velocity*:math.sin(theta)
  end
end
