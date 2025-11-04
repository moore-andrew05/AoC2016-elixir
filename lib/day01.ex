defmodule Aoc2016.Day01 do
  defp input do
    String.trim(File.read!("priv/inputs/day01.txt"))
  end

  def part1(), do: part1(input())

  @doc """

  """
  def part1(input) do
    steps = String.split(input, ", ")

    {_, xdist, ydist} =
      Enum.reduce(steps, {0, 0, 0}, fn step, {dir, x, y} ->
        {curr_dir, val} =
          case step do
            "R" <> val -> {dir + 1, val}
            "L" <> val -> {dir + 3, val}
            _ -> dir
          end

        val = String.to_integer(val)
        dir_solved = rem(curr_dir, 4)

        case dir_solved do
          0 -> {curr_dir, x, y + val}
          1 -> {curr_dir, x + val, y}
          2 -> {curr_dir, x, y - val}
          3 -> {curr_dir, x - val, y}
        end
      end)

    abs(xdist) + abs(ydist)
  end

  def part2(), do: part2(input())

  def part2(input) do
    steps = String.split(input, ", ")

    Enum.reduce_while(steps, {0, 0, 0, MapSet.new()}, fn step, {dir, x, y, visited} ->
      {curr_dir, val} =
        case step do
          "R" <> val -> {dir + 1, val}
          "L" <> val -> {dir + 3, val}
        end

      val = String.to_integer(val)
      dir_solved = rem(curr_dir, 4)

      {newx, newy} =
        case dir_solved do
          0 -> {x, y + val}
          1 -> {x + val, y}
          2 -> {x, y - val}
          3 -> {x - val, y}
        end

      passthrough =
        case dir_solved do
          n when n == 0 or n == 2 -> Enum.map(y..newy, fn a -> {x, a} end)
          n when n == 1 or n == 3 -> Enum.map(x..newx, fn a -> {a, y} end)
        end

      [_ | passthrough] = passthrough

      has_key = Enum.any?(passthrough, fn a -> MapSet.member?(visited, a) end)

      if has_key do
        {x, y} =
          Enum.reduce_while(passthrough, 0, fn pass, _ ->
            if MapSet.member?(visited, pass) do
              {:halt, pass}
            else
              {:cont, {}}
            end
          end)

        {:halt, abs(x) + abs(y)}
      else
        new_visited =
          case dir_solved do
            n when n == 0 or n == 2 -> Enum.map(y..newy, fn a -> {x, a} end)
            n when n == 1 or n == 3 -> Enum.map(x..newx, fn a -> {a, y} end)
          end
          |> MapSet.new()

        {:cont, {curr_dir, newx, newy, MapSet.union(visited, new_visited)}}
      end
    end)
  end
end
