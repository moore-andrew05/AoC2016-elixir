defmodule Aoc2016.Day01Test do
  use ExUnit.Case
  alias Aoc2016.Day01

  describe "part1/1" do
    test "returns_distance" do
      assert Day01.part1("R2, L3") == 5
      assert Day01.part1("R2, R2, R2") == 2
      assert Day01.part1("R5, L5, R5, R3") == 12
    end
  end

  describe "part2/1" do
    test "returns distance of first revisited location" do
      assert Day01.part2("R8, R4, R4, R8") == 4
    end
  end
end
