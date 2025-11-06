defmodule Aoc2016.Day03 do
  defp input do
    String.trim(File.read!("priv/inputs/day03.txt"))
  end

  defp boolean_to_int(true), do: 1
  defp boolean_to_int(false), do: 0
    

  def is_triangle(sides) do
    Enum.max(sides) < Enum.sum(sides) - Enum.max(sides)
  end

  def process_row(row) do
    row
    |> Enum.map(&String.to_integer(&1))
    |> is_triangle()
  end

  def part1(), do: part1(input())
  

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&process_row(&1))
    |> Enum.map(&boolean_to_int(&1))
    |> Enum.sum()
  end

  def part2(), do: part2(input())

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.chunk_every(3)
    |> Enum.flat_map(&Enum.zip(&1))
    |> Enum.map(&Tuple.to_list(&1))
    |> Enum.map(&process_row(&1))
    |> Enum.count(fn x -> x == true end)
  end
end
