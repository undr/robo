# Robo

The application is a simulation of a toy robot moving on a square tabletop.
Available commands:

- `MOVE`
- `LEFT`
- `RIGHT`
- `REPORT`
- `PLACE x,y,FACING`

The origin (0,0) can be considered to be the SOUTH WEST most corner.
FACING can be any of: `NORTH`, `EAST`, `SOUTH`, `WEST`.

## Installation

```
brew update
brew install elixir
mix escript.build
```

## Usage

```
./robo --help

Robo is a solution of test task for Locomote company.
Usage: robo [options]

  --file FILE   File with a list of commands. Omit this option if you want read commands from console.
  --size SIZE   Size of a table (default: 5).
  --help        This info.

Examples:
  robo --file ./comands.txt --size 25
```

## Tests

```
mix test
```
