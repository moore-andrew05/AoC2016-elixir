defmodule Aoc2016.Day19 do
  import Math

  defp input do
    3014387
  end

  defp jump(curr_position, curr_round, num_elves, scale) do
    attempted_jump = curr_position + (scale * curr_round)
    case attempted_jump - num_elves do
      x when x <= 0 -> {curr_round, attempted_jump}
      x when x > 0 -> {curr_round + 1, rem(1 + attempted_jump - (num_elves - curr_position), num_elves)}
    end
  end

  get_first_valid(1)


  def find_position(num_elves, max_rounds, curr_position, curr_round, last_round) do
    last_round = cond do
      curr_round > last_round ->
        IO.puts("Starting at #{curr_position} for round #{curr_round}")
        curr_round
      true -> last_round
    end
    {_, takes} = jump(curr_position, curr_round, num_elves, 1)
    {next_round, next_pos} = jump(curr_position, curr_round, num_elves, 2)

    IO.puts("Elf #{curr_position} takes elf #{takes}.")

    cond do
      next_round >= max_rounds -> curr_position
      true -> find_position(num_elves, max_rounds, next_pos, next_round, last_round)
    end
  end

  
  def part1(), do: part1(input())

  def part1(input) do
    find_position(input, ceil(Math.log2(input)), 1, 1, 1)
  end

  def part2(), do: part2(input())

  def part2(input) do
  end
end
