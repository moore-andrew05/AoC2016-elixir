defmodule Item do
  @enforce_keys [:element, :type]
  defstruct [
    :element,
    :type
  ]
end

defmodule Floor do
  @enforce_keys [:items]
  defstruct [
    :items
  ]
end

defmodule FloorState do
  @enforce_keys [:floors, :elevator_pos]
  defstruct [
    :floors,
    :elevator_pos
  ]
end

defmodule Aoc2016.Day11 do
  defp input do
    String.trim(File.read!("priv/inputs/day11.txt"))
  end

  defp parse_input_row(row) do
    generators =
      Regex.scan(~r/(?<generators>\w+) generator/, row, capture: :first)
      |> List.flatten()

    chips =
      Regex.scan(~r/(?<microchips>\w+)-compatible microchip/, row, capture: :first)
      |> List.flatten()

    generators =
      generators
      |> Enum.reduce([], fn x, gens ->
        item = %Item{
          element: String.to_atom(x),
          type: :gen
        }

        [item | gens]
      end)

    chips =
      chips
      |> Enum.reduce([], fn x, chips ->
        item = %Item{
          element: String.to_atom(x),
          type: :chip
        }

        [item | chips]
      end)
    %Floor{
      items: generators ++ chips
    }
  end

  defp process_input(input) do
    floors =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_input_row(&1))
  end

  def part1(), do: part1(input())

  def part1(input) do
    process_input(input)
  end

  def part2(), do: part2(input())

  def part2(input) do
  end
end
