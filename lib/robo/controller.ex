defmodule Robo.Controller do
  use GenServer

  alias Robo.Table
  alias Robo.Robot

  @command_regexp ~r[^(?<command>MOVE|REPORT|LEFT|RIGHT|PLACE)(?<args>\s+\d+,\s*\d+,\s*(?:EAST|NORTH|WEST|SOUTH){1})*$]iu

  def start_link(table) do
    GenServer.start(__MODULE__, { table, nil }, [name: __MODULE__])
  end

  def init(state) do
    { :ok, state }
  end

  def execute(command) do
    case parse_command(command) do
      { "REPORT", [] }            -> report()
      { "RIGHT", [] }             -> right()
      { "LEFT", [] }              -> left()
      { "MOVE", [] }              -> move()
      { "PLACE", [x, y, facing] } ->
        place(Robot.create(String.to_integer(x), String.to_integer(y), String.upcase(facing)))
      _                           -> nil
    end
  end

  def report do
    case GenServer.call(__MODULE__, :get) do
      { _, nil }   -> "First you should place the robot on a table using command: PLACE"
      { _, robot } -> inspect(robot.x) <> "," <> inspect(robot.y) <> "," <> robot.facing
    end
  end

  @doc """
  Execute `MOVE` command
  ## Example
      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE 2,2,NORTH")
      iex> Robo.Controller.execute("MOVE")
      iex> Robo.Controller.execute("REPORT")
      "3,2,NORTH"
      iex> Robo.Controller.execute("moVe")
      iex> Robo.Controller.execute("REPORT")
      "4,2,NORTH"
      iex> Robo.Controller.execute("Move")
      iex> Robo.Controller.execute("REPORT")
      "4,2,NORTH"
      iex> GenServer.stop(Robo.Controller)
      :ok

      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE 2,2,EAST")
      iex> Robo.Controller.execute("MOVE")
      iex> Robo.Controller.execute("REPORT")
      "2,3,EAST"
      iex> Robo.Controller.execute("moVe")
      iex> Robo.Controller.execute("REPORT")
      "2,4,EAST"
      iex> Robo.Controller.execute("Move")
      iex> Robo.Controller.execute("REPORT")
      "2,4,EAST"
      iex> GenServer.stop(Robo.Controller)
      :ok

      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE 2,2,SOUTH")
      iex> Robo.Controller.execute("MOVE")
      iex> Robo.Controller.execute("REPORT")
      "1,2,SOUTH"
      iex> Robo.Controller.execute("moVe")
      iex> Robo.Controller.execute("REPORT")
      "0,2,SOUTH"
      iex> Robo.Controller.execute("Move")
      iex> Robo.Controller.execute("REPORT")
      "0,2,SOUTH"
      iex> GenServer.stop(Robo.Controller)
      :ok

      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE 2,2,WEST")
      iex> Robo.Controller.execute("MOVE")
      iex> Robo.Controller.execute("REPORT")
      "2,1,WEST"
      iex> Robo.Controller.execute("moVe")
      iex> Robo.Controller.execute("REPORT")
      "2,0,WEST"
      iex> Robo.Controller.execute("Move")
      iex> Robo.Controller.execute("REPORT")
      "2,0,WEST"
      iex> GenServer.stop(Robo.Controller)
      :ok
  """
  def move do
    GenServer.cast(__MODULE__, :move)
    nil
  end

  @doc """
  Execute `LEFT` command
  ## Example
      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE 2,2,NORTH")
      iex> Robo.Controller.execute("LEFT")
      iex> Robo.Controller.execute("REPORT")
      "2,2,WEST"
      iex> Robo.Controller.execute("LeFt")
      iex> Robo.Controller.execute("REPORT")
      "2,2,SOUTH"
      iex> Robo.Controller.execute("Left")
      iex> Robo.Controller.execute("REPORT")
      "2,2,EAST"
      iex> Robo.Controller.execute("left")
      iex> Robo.Controller.execute("REPORT")
      "2,2,NORTH"
      iex> GenServer.stop(Robo.Controller)
      :ok
  """
  def left do
    GenServer.cast(__MODULE__, :left)
    nil
  end

  @doc """
  Execute `RIGHT` command
  ## Example
      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE 2,2,NORTH")
      iex> Robo.Controller.execute("RIGHT")
      iex> Robo.Controller.execute("REPORT")
      "2,2,EAST"
      iex> Robo.Controller.execute("RiGht")
      iex> Robo.Controller.execute("REPORT")
      "2,2,SOUTH"
      iex> Robo.Controller.execute("Right")
      iex> Robo.Controller.execute("REPORT")
      "2,2,WEST"
      iex> Robo.Controller.execute("right")
      iex> Robo.Controller.execute("REPORT")
      "2,2,NORTH"
      iex> GenServer.stop(Robo.Controller)
      :ok
  """
  def right do
    GenServer.cast(__MODULE__, :right)
    nil
  end

  @doc """
  Execute `RIGHT` command
  ## Example
      iex> Robo.Controller.start_link(%Robo.Table{ width: 5, height: 5 })
      iex> Robo.Controller.execute("PLACE")
      iex> Robo.Controller.execute("REPORT")
      "First you should place the robot on a table using command: PLACE"
      iex> Robo.Controller.execute("PLACE 1")
      iex> Robo.Controller.execute("REPORT")
      "First you should place the robot on a table using command: PLACE"
      iex> Robo.Controller.execute("PLACE 1,1")
      iex> Robo.Controller.execute("REPORT")
      "First you should place the robot on a table using command: PLACE"
      iex> Robo.Controller.execute("PLACE a,b,EAST")
      iex> Robo.Controller.execute("REPORT")
      "First you should place the robot on a table using command: PLACE"
      iex> Robo.Controller.execute("PLACE 1,-1,EAST")
      iex> Robo.Controller.execute("REPORT")
      "First you should place the robot on a table using command: PLACE"
      iex> Robo.Controller.execute("PLACE 10,1,EAST")
      iex> Robo.Controller.execute("REPORT")
      "First you should place the robot on a table using command: PLACE"
      iex> Robo.Controller.execute("PLACE 1,1,EAST")
      iex> Robo.Controller.execute("REPORT")
      "1,1,EAST"
      iex> Robo.Controller.execute("PLACE 0,0,NORTH")
      iex> Robo.Controller.execute("REPORT")
      "0,0,NORTH"
      iex> Robo.Controller.execute("PLACE 4,4,WEST")
      iex> Robo.Controller.execute("REPORT")
      "4,4,WEST"
      iex> Robo.Controller.execute("PLACE 10,1,EAST")
      iex> Robo.Controller.execute("REPORT")
      "4,4,WEST"
      iex> GenServer.stop(Robo.Controller)
      :ok
  """
  def place(nil) do
    nil
  end

  def place(robot = %Robot{}) do
    GenServer.cast(__MODULE__, { :place, robot })
    nil
  end

  def handle_call(:get, _from, state) do
    { :reply, state, state }
  end

  def handle_cast({ :place, new_robot }, { table, robot }) do
    { :noreply, { table, choose_valid_robot(table, new_robot, robot) } }
  end

  def handle_cast(_, { _, nil } = state) do
    { :noreply, state }
  end

  def handle_cast(:move, { table, robot }) do
    new_robot = Robot.move_forward(robot)
    { :noreply, { table, choose_valid_robot(table, new_robot, robot) } }
  end

  def handle_cast(:left, { table, robot }) do
    new_robot = Robot.turn_left(robot)
    { :noreply, { table, choose_valid_robot(table, new_robot, robot) } }
  end

  def handle_cast(:right, { table, robot }) do
    new_robot = Robot.turn_right(robot)
    { :noreply, { table, choose_valid_robot(table, new_robot, robot) } }
  end

  defp choose_valid_robot(table, new_robot, old_robot) do
    if Table.inside_table?(table, new_robot) do
      new_robot
    else
      old_robot
    end
  end

  defp parse_command(command) do
    case Regex.named_captures(@command_regexp, command) do
      %{ "command" => command, "args" => "" }   -> { String.upcase(command), [] }
      %{ "command" => command, "args" => args } -> { String.upcase(command), parse_args(args) }
      nil                                       -> nil
    end
  end

  defp parse_args(args) do
    args |> String.split(",") |> Enum.map(&String.trim/1)
  end
end
