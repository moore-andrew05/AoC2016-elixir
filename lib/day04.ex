defmodule Aoc2016.Day04 do
  defp input do
    String.trim(File.read!("priv/inputs/day04.txt"))
  end

  defp parse_id_and_checksum(s) do
    Regex.named_captures(~r/\](?<checksum>.*?)\[(?<id>\d+)/, s)
  end

  def process_row(row) do
    [checkid | vals] = row

    expected =
      Enum.join(vals)
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.to_list()
      |> Enum.sort_by(&elem(&1, 1), :desc)
      |> Enum.map(&elem(&1, 0))
      |> Enum.join()
      |> String.slice(0..4)

    checkid = parse_id_and_checksum(checkid)

    {expected, checkid}
  end

  def part1(), do: part1(input())

  def part1(input) do
    parsed =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.reverse(&1))
      |> Enum.map(&String.split(&1, "-", trim: true))

    res =
      Enum.map(parsed, fn x ->
        process_row(x)
      end)

    Enum.reduce(res, 0, fn row, acc ->
      {expected, checkid} = row

      check =
        Map.get(checkid, "checksum")
        |> String.reverse()

      case check do
        ^expected -> acc + (Map.get(checkid, "id") |> String.reverse() |> String.to_integer())
        _ -> acc
      end
    end)
  end

  def shift_cipher1(s, shift) do
    calc_shift = rem(shift, 26)
    s
    |> String.graphemes()
    |> Enum.map(fn x ->
      <<v::utf8>> = x
      <<rem((v-97) + calc_shift, 26) + 97::utf8>>
    end)
    |> Enum.join()
  end

  def part2(), do: part2(input())

  def part2(input) do
    parsed =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.reverse(&1))
      |> Enum.map(&String.split(&1, "-", trim: true))

    Enum.map(parsed, fn x ->
      [checkid | name] = x

      id = parse_id_and_checksum(checkid) 
      |> Map.get("id") 
      |> String.reverse()
      |> String.to_integer()

      name =
        Enum.reverse(name)
        |> Enum.map(&String.reverse(&1))
      IO.inspect(name)

sol = Enum.join(name)
       |> shift_cipher1(id)
      IO.puts(sol)

      IO.puts(id)

    end)
  end
end
