defmodule Robo.CLI do
  @default_table_size 5

  alias Robo.Table
  alias Robo.Controller

  def main(args) do
    args
    |> parse_args
    |> start_application
    |> read_input
    |> process(IO.stream(:stdio, :line))
  end

  @doc """
  Parse arguments coming from console
  ## Example
      iex> Robo.CLI.parse_args(["--file", "./commands.txt"])
      [file: "./commands.txt"]
      iex> Robo.CLI.parse_args(["--size", "10"])
      [size: 10]
      iex> Robo.CLI.parse_args(["--file", "./commands.txt", "--size", "10"])
      [file: "./commands.txt", size: 10]
      iex> Robo.CLI.parse_args(["--unknown", "argument", "--size", "10"])
      [unknown: "argument", size: 10]
      iex> Robo.CLI.parse_args([])
      []
  """
  def parse_args(args) do
    { options, _, _ } = OptionParser.parse(
      args,
      switches: [file: :string, size: :integer, help: :boolean],
      aliases: [h: :help, s: :size, f: :file]
    )

    case Keyword.get(options, :help) do
      true ->
        print_help()
        exit(:shutdown)
      _    -> options
    end
  end

  def print_help do
    IO.puts """
    Robo is a solution of test task for Locomote company.
    Usage: robo [options]

      --file FILE   File with a list of commands. Omit this option if you want read commands from console.
      --size SIZE   Size of a table (default: 5).
      --help        This info.

    Examples:
      robo --file ./comands.txt --size 25
    """
  end

  def process(input, output) do
    try do
      input
      |> Stream.map(&String.trim/1)
      |> Stream.map(fn command -> Controller.execute(command) end)
      |> Stream.reject(&Kernel.is_nil/1)
      |> Stream.map(&(&1 <> "\n"))
      |> Stream.into(output)
      |> Stream.run
    rescue
      _error in File.Error ->
        IO.puts("Error: cannot read from " <> inspect(input.path) <> " file")
        exit(:shutdown)
    end
  end

  defp start_application(options) do
    Robo.Application.start(:normal, [create_table(Keyword.get(options, :size))])
    options
  end

  defp read_input(options) do
    case Keyword.get(options, :file) do
      nil  ->
        IO.puts("Read commands from console.")
        IO.puts("Available commands: MOVE, LEFT, RIGHT, REPORT and PLACE x,y,FACING.")
        IO.puts("Press Control+C for exit.")
        IO.puts("")
        IO.stream(:stdio, :line)

      file ->
        IO.puts("Read commands from " <> inspect(file) <> " file")
        IO.puts("")
        File.stream!(file)
    end
  end

  defp create_table(nil) do
    IO.puts "Creating table with size " <> inspect(@default_table_size) <> "..."
    %Table{ width: @default_table_size, height: @default_table_size }
  end

  defp create_table(size) do
    IO.puts "Creating table with size " <> inspect(size) <> "..."
    %Table{ width: size, height: size }
  end
end
