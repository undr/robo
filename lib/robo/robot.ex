defmodule Robo.Robot do
  defstruct [:x, :y, :facing]

  @facings ["NORTH", "EAST", "SOUTH", "WEST"]

  @doc """
  Create the robot
  ## Example
      iex> Robo.Robot.create(2, 2, "NORTH")
      %Robo.Robot{ x: 2, y: 2, facing: "NORTH" }
      iex> Robo.Robot.create(2, 2, "EAST")
      %Robo.Robot{ x: 2, y: 2, facing: "EAST" }
      iex> Robo.Robot.create(2, 2, "SOUTH")
      %Robo.Robot{ x: 2, y: 2, facing: "SOUTH" }
      iex> Robo.Robot.create(2, 2, "WEST")
      %Robo.Robot{ x: 2, y: 2, facing: "WEST" }

      iex> Robo.Robot.create(-1, -1, "NORTH")
      nil
      iex> Robo.Robot.create(0, 0, "NORT")
      nil

      iex> Robo.Robot.create(nil, 0, "NORTH")
      nil
      iex> Robo.Robot.create(0, nil, "NORTH")
      nil
      iex> Robo.Robot.create(0, 0, nil)
      nil
      iex> Robo.Robot.create("w", "d", "NORTH")
      nil
      iex> Robo.Robot.create(nil, nil, "NORTH")
      nil
  """
  def create(nil, _y, _facing), do: nil
  def create(_x, nil, _facing), do: nil
  def create(_x, _y, nil),      do: nil
  def create(x, y, facing) do
    cond do
      !is_integer(x) || x < 0         -> nil
      !is_integer(y) || y < 0         -> nil
      !Enum.member?(@facings, facing) -> nil
      true                            -> %Robo.Robot{ x: x, y: y, facing: facing }
    end
  end

  @doc """
  Turn the robot left
  ## Example
      iex> Robo.Robot.turn_left(%Robo.Robot{ x: 2, y: 2, facing: "NORTH" })
      %Robo.Robot{ x: 2, y: 2, facing: "WEST" }
      iex> Robo.Robot.turn_left(%Robo.Robot{ x: 2, y: 2, facing: "WEST" })
      %Robo.Robot{ x: 2, y: 2, facing: "SOUTH" }
      iex> Robo.Robot.turn_left(%Robo.Robot{ x: 2, y: 2, facing: "SOUTH" })
      %Robo.Robot{ x: 2, y: 2, facing: "EAST" }
      iex> Robo.Robot.turn_left(%Robo.Robot{ x: 2, y: 2, facing: "EAST" })
      %Robo.Robot{ x: 2, y: 2, facing: "NORTH" }
  """
  def turn_left(robot) do
    turn(robot, -1)
  end

  @doc """
  Turn the robot right
  ## Example
      iex> Robo.Robot.turn_right(%Robo.Robot{ x: 2, y: 2, facing: "NORTH" })
      %Robo.Robot{ x: 2, y: 2, facing: "EAST" }
      iex> Robo.Robot.turn_right(%Robo.Robot{ x: 2, y: 2, facing: "EAST" })
      %Robo.Robot{ x: 2, y: 2, facing: "SOUTH" }
      iex> Robo.Robot.turn_right(%Robo.Robot{ x: 2, y: 2, facing: "SOUTH" })
      %Robo.Robot{ x: 2, y: 2, facing: "WEST" }
      iex> Robo.Robot.turn_right(%Robo.Robot{ x: 2, y: 2, facing: "WEST" })
      %Robo.Robot{ x: 2, y: 2, facing: "NORTH" }
  """
  def turn_right(robot) do
    turn(robot, 1)
  end

  @doc """
  Move the robot one cell ahead
  ## Example
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 2, y: 2, facing: "NORTH" })
      %Robo.Robot{ x: 3, y: 2, facing: "NORTH" }
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 2, y: 2, facing: "EAST" })
      %Robo.Robot{ x: 2, y: 3, facing: "EAST" }
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 2, y: 2, facing: "SOUTH" })
      %Robo.Robot{ x: 1, y: 2, facing: "SOUTH" }
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 2, y: 2, facing: "WEST" })
      %Robo.Robot{ x: 2, y: 1, facing: "WEST" }

      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 0, y: 0, facing: "NORTH" })
      %Robo.Robot{ x: 1, y: 0, facing: "NORTH" }
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 0, y: 0, facing: "EAST" })
      %Robo.Robot{ x: 0, y: 1, facing: "EAST" }
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 0, y: 0, facing: "SOUTH" })
      %Robo.Robot{ x: -1, y: 0, facing: "SOUTH" }
      iex> Robo.Robot.move_forward(%Robo.Robot{ x: 0, y: 0, facing: "WEST" })
      %Robo.Robot{ x: 0, y: -1, facing: "WEST" }
  """
  def move_forward(robot) do
    case robot.facing do
      "NORTH" -> %{ robot | x: robot.x + 1 }
      "EAST"  -> %{ robot | y: robot.y + 1 }
      "SOUTH" -> %{ robot | x: robot.x - 1 }
      "WEST"  -> %{ robot | y: robot.y - 1 }
      _       -> robot
    end
  end

  defp turn(robot, direction) do
    index = Enum.find_index(@facings, &(&1 == robot.facing)) + direction
    index = if index > 3, do: 0, else: index
    index = if index < 0, do: 3, else: index
    new_facing = Enum.at(@facings, index)
    %{ robot | facing: new_facing }
  end
end
