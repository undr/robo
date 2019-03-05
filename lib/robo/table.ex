defmodule Robo.Table do
  defstruct [:width, :height]

  @doc """
  Check if the robot is placed inside the table.
  ## Example
      iex> Robo.Table.inside_table?(%Robo.Table{ width: 5, height: 5 }, %Robo.Robot{ x: 4, y: 4, facing: "NORTH" })
      true
      iex> Robo.Table.inside_table?(%Robo.Table{ width: 5, height: 5 }, %Robo.Robot{ x: 0, y: 0, facing: "NORTH" })
      true
      iex> Robo.Table.inside_table?(%Robo.Table{ width: 5, height: 5 }, %Robo.Robot{ x: 5, y: 2, facing: "NORTH" })
      false
      iex> Robo.Table.inside_table?(%Robo.Table{ width: 5, height: 5 }, %Robo.Robot{ x: 2, y: 5, facing: "NORTH" })
      false
      iex> Robo.Table.inside_table?(%Robo.Table{ width: 5, height: 5 }, %Robo.Robot{ x: -1, y: 2, facing: "NORTH" })
      false
      iex> Robo.Table.inside_table?(%Robo.Table{ width: 5, height: 5 }, %Robo.Robot{ x: 2, y: -1, facing: "NORTH" })
      false
  """
  def inside_table?(table, robot) do
    robot.x < table.width && robot.y < table.height && robot.x >= 0 && robot.y >= 0
  end
end
