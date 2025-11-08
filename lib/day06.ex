defmodule Aoc2016.Day06 do
  defp input do
    String.trim(File.read!("priv/inputs/day06.txt"))
  end
  def part1(), do: part1(input())

  def part1(input) do
    frequencies = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&Enum.frequencies(&1))

    frequencies
    |> Enum.map(&Map.to_list(&1))
    |> Enum.map(fn x -> Enum.sort_by(x, &elem(&1, 1), :desc)end)
    |> Enum.map(&List.first(&1))
    |> Enum.map_join("", &elem(&1, 0))

  end


  def part2(), do: part2(input())

  def part2(input) do
    frequencies = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&Enum.frequencies(&1))

    frequencies
    |> Enum.map(&Map.to_list(&1))
    |> Enum.map(fn x -> Enum.sort_by(x, &elem(&1, 1), :asc)end)
    |> Enum.map(&List.first(&1))
    |> Enum.map_join("", &elem(&1, 0))

  end
end
