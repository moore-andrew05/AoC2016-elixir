defmodule Aoc2016.Day09 do
  @marker_regex ~r/\((?<capture>\d+)x(?<repetitions>\d+)\)/

  defp input do
    String.trim(File.read!("priv/inputs/day09.txt"))
  end

  def part1(), do: part1(input())

  def match_first_marker(code_string) do
    {index, marker_length} =
      Regex.run(@marker_regex, capture: :first, return: :index) |> Enum.at(0)

    captures = Regex.run(@marker_regex, capture: :first)
    {index, marker_length, captures}
  end

  def part1(input) do
    Stream.iterate(0, fn x -> 

    end)
  end

  def part2(), do: part2(input())

  def part2(input) do
  end
end
