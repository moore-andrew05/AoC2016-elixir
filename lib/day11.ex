defmodule RC do
  def comb(0, _), do: [[]]
  def comb(_, []), do: []
  def comb(m, [h|t]) do
    (for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
  end
end

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
  use Agent

  defp input do
    String.trim(File.read!("priv/inputs/day11.txt"))
  end

  def start_memo do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  defp parse_input_row(row) do
    generators =
      Regex.scan(~r/(?<generators>\w+) generator/, row, capture: :all_but_first)
      |> List.flatten()

    chips =
      Regex.scan(~r/(?<microchips>\w+)-compatible microchip/, row, capture: :all_but_first)
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

  defp validate_floor(floor) do
    has_generator = Enum.any?(floor.items, fn x -> x.type == :gen end)

    elems =
      floor.items
      |> Enum.group_by(&{&1.element})
      |> Map.filter(fn {_key, val} -> length(val) == 1 end)
      |> Map.filter(fn {_key, val} -> List.first(val).type == :chip end)

    if Map.size(elems) > 0 and has_generator do
      false
    else
      true
    end
  end

  def part1(), do: part1(input())

  def part1(input) do
    data = process_input(input)

    data
  end

  def part2(), do: part2(input())

  def part2(input) do
  end
end
