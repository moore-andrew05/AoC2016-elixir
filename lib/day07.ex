defmodule Aoc2016.Day07 do
  @part1_regex ~r/(?<out>\w+)\[?(?<in>\w+)?\]?/
  defp input do
    String.trim(File.read!("priv/inputs/day07.txt"))
  end

  def char_group_aba?(group) do
    [a, b, c] = group

    if a == c and a != b do
      true
    else
      false
    end
  end

  def char_group_valid?(group) do
    [a, b, c, d] = group

    if a == d and b == c and a != b do
      true
    else
      false
    end
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

  defp chunk_valid?(chunk) do
    chunks =
      chunk
      |> String.graphemes()
      |> Enum.chunk_every(4, 1, :discard)

    chunks
    |> Enum.reduce_while(true, fn x, _valid ->
      if char_group_valid?(x) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  def ipv7_valid?(ip) do
    {out_strs, in_strs} =
      ip
      |> parse_line()

    out_valid =
      out_strs
      |> Enum.map(&chunk_valid?(&1))

    in_valid =
      in_strs
      |> Enum.map(&chunk_valid?(&1))

    if Enum.any?(out_valid) and not Enum.any?(in_valid) do
      true
    else
      false
    end
  end

  defp get_abas(str) do
    chunks =
      str
      |> String.graphemes()
      |> Enum.chunk_every(3, 1, :discard)

    chunks
    |> Enum.reduce(MapSet.new(), fn x, aba_set ->
      [a, b, _] = x
      cond do
        char_group_aba?(x) -> MapSet.put(aba_set, Enum.join([b, a, b]))
        true -> aba_set
      end
    end)
  end

  def process_abas(out_strs) do
    out_strs
    |> Enum.reduce(MapSet.new(), fn x, aba_set ->
      MapSet.union(aba_set, get_abas(x))
    end)
  end

  defp chunk_valid_bab?(aba_set, chunk) do
    chunk
    |> String.graphemes()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.reduce_while(false, fn x, _valid ->
      if MapSet.member?(aba_set, Enum.join(x)) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  def ipv7_supports_ssl?(ip) do
    {out_strs, in_strs} =
      ip
      |> parse_line()

    valid_abas = process_abas(out_strs)

    in_strs
    |> Enum.reduce_while(false, fn x, _valid ->
      if chunk_valid_bab?(valid_abas, x) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&ipv7_valid?(&1))
    |> Enum.count(fn x -> x end)
  end

  def part2(), do: part2(input())

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&ipv7_supports_ssl?(&1))
    |> Enum.count(fn x -> x end)
  end
end
