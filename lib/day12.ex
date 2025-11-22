defmodule Aoc2016.Day12 do
  defp input do
    String.trim(File.read!("priv/inputs/day12.txt"))
  end

  def process_instruction(["cpy", val, target], registers) when (val >= "a") and (val <= "d") do
    val = Map.get(registers, val)

    {Map.put(registers, target, val), 1}
  end

  def process_instruction(["cpy", val, target], registers) do
    {Map.put(registers, target, String.to_integer(val)), 1}
  end

  def process_instruction(["inc", target], registers) do
    {Map.update!(registers, target, fn x -> x + 1 end), 1}
  end

  def process_instruction(["dec", target], registers) do
    {Map.update!(registers, target, fn x -> x - 1 end), 1}
  end

  def process_instruction(["jnz", target, val], registers) do
    register_value = Map.get(registers, target)

    case register_value do
      0 -> {registers, 1}
      _ -> {registers, String.to_integer(val)}
    end
  end

  def step_through(_, stk_length, registers, pos) when pos > stk_length - 1  do
    registers
  end

  def step_through(stk, stk_length, registers, pos) do
    {registers, jmp} = process_instruction(elem(stk, pos), registers) 
    step_through(stk, stk_length, registers, pos + jmp)
  end

  def part1(), do: part1(input())

  def part1(input) do
    stk =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    stk_length = length(stk)
    stk = List.to_tuple(stk)

    registers = %{"a" => 0, "b" => 0, "c" => 0, "d" => 0}
    step_through(stk, stk_length, registers, 0)

  end

  def part2(), do: part2(input())

  def part2(input) do
    stk =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    stk_length = length(stk)
    stk = List.to_tuple(stk)

    registers = %{"a" => 0, "b" => 0, "c" => 1, "d" => 0}
    step_through(stk, stk_length, registers, 0)
  end
end
