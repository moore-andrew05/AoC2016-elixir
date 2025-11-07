defmodule Aoc2016.Day05 do
  defp input do
    "ojvtpuvg"
  end

  def part1(), do: part1(input())

  def part1(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({0, ""}, fn idx, {len, pass} ->
      to_hash = input <> Integer.to_string(idx)

      <<val::utf8, check::binary>> =
        :crypto.hash(:md5, to_hash)
        |> Base.encode16(case: :lower)
        |> String.slice(0..5)
        |> String.reverse()

      {len, pass} =
        case check do
          "00000" -> {len + 1, pass <> <<val::utf8>>}
          _ -> {len, pass}
        end

      if len == 8 do
        {:halt, pass}
      else
        {:cont, {len, pass}}
      end
    end)
  end

  def part2(), do: part2(input())


  defp insert_if_not_present(map, key, value) when key in 0..7 do
    IO.puts("Found #{value} at position #{key}")
    cond do
      Map.has_key?(map, key) -> map
      true -> Map.put(map, key, value)
    end
  end

  defp insert_if_not_present(map, _key, _value) do
    map
  end
  def part2(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(%{}, fn idx, pass ->
      to_hash = input <> Integer.to_string(idx)

      <<val::utf8, pos::utf8, check::binary>> =
        :crypto.hash(:md5, to_hash)
        |> Base.encode16(case: :lower)
        |> String.slice(0..6)
        |> String.reverse()

      pass =
        case check do
          "00000" -> insert_if_not_present(pass, pos - 48, val)
          _ -> pass
        end

      if Kernel.map_size(pass) == 8 do
        {:halt, pass}
      else
        {:cont, pass}
      end
    end)
    |> Map.to_list()
    |> Enum.sort_by(&elem(&1, 0), :asc)
    |> Enum.map(&elem(&1, 1))
    |> List.to_string()
  end
end
