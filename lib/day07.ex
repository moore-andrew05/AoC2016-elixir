defmodule Aoc2016.Day07 do
  @part1_regex ~r/(?<out>\w+)\[?(?<in>\w+)?\]?/
  defp input do
    String.trim(File.read!("priv/inputs/day07.txt"))
  end

  def parse_line(line) do
    regex_parse = Regex.scan(@part1_regex, line)

    regex_parse
    |> Enum.reduce({[], []}, fn x, {out_paren, in_paren} ->
      case x do
        [_, out_elem, in_elem] -> {[out_elem | out_paren], [in_elem | in_paren]}
        [_, out_elem] -> {[out_elem | out_paren], in_paren}
        _ -> {out_paren, in_paren}
      end
    end)
  end

  def part1(), do: part1(input())

  def part1(input) do
  end

  def part2(), do: part2(input())

  def part2(input) do
  end
end
