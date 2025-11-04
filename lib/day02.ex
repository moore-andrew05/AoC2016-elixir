defmodule Aoc2016.Day02 do
  @keypad %{
    {2, 0} => "1",
    {1, 1} => "2", {2, 1} => "3", {3, 1} => "4",
    {0, 2} => "5", {1, 2} => "6", {2, 2} => "7", {3, 2} => "8", {4, 2} => "9",
    {1, 3} => "A", {2, 3} => "B", {3, 3} => "C",
    {2, 4} => "D"
  }

  defp input do
    String.trim(File.read!("priv/inputs/day02.txt"))
  end

  defp get_value_from_coords(x, y) do
    x + 1 + y * 3
  end

  defp get_value_from_coords2(x, y) do
    Map.get(@keypad, {x, y})
  end

  defp apply_transformation2(x, y, dx, dy) do
    {newx, newy} = {x + dx, y + dy}

    if Map.has_key?(@keypad, {newx, newy}) do
      {newx, newy}
    else
      {x, y}
    end
  end

  defp apply_transformation(x, y, dx, dy, size \\ {3, 3}) do
    {newx, newy} = {x + dx, y + dy}
    {xlim, ylim} = size

    if newx > -1 and newx < xlim and newy > -1 and newy < ylim do
      {newx, newy}
    else
      {x, y}
    end
  end

  def process_row(row, starting_pos \\ {1, 1}, f \\ &apply_transformation/4) do
    row = String.graphemes(row)

    Enum.reduce(row, starting_pos, fn char, {x, y} ->
      case char do
        "U" -> f.(x, y, 0, -1)
        "D" -> f.(x, y, 0, 1)
        "L" -> f.(x, y, -1, 0)
        "R" -> f.(x, y, 1, 0)
        _ -> {x, y}
      end
    end)
  end

  def part1(), do: part1(input())

  @doc """

  """

  def part1(input) do
    lines = input |> String.split("\n")
    {res, _} = Enum.map_reduce(lines, {1, 1}, fn line, {x, y} ->
      {x, y} = process_row(line, {x, y})
      {{x, y}, {x, y}}
    end)
      Enum.map(res, fn {x, y} -> get_value_from_coords(x, y)end)

  end
  
  def part2(), do: part2(input())

  def part2(input) do
    input 
    |> String.split("\n")
    |> Enum.map_reduce({0, 2}, fn line, pos ->
      pos = process_row(line, pos, &apply_transformation2/4)
      {pos, pos}
    end)
    |> elem(0)
    |> Enum.map(fn {x, y} -> get_value_from_coords2(x, y)end)
  end
end
