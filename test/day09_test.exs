defmodule Aoc2016.Day09Test do
  use ExUnit.Case
  alias Aoc2016.Day09

  describe "part1/1" do
    test "Uncompressed length" do
      assert Day09.part1("ADVENT") == 6
      assert Day09.part1("A(1x5)BC") == 7
      assert Day09.part1("(3x3)XYZ") == 9
      assert Day09.part1("A(2x2)BCD(2x2)EFG") == 11
      assert Day09.part1("(6x1)(1x3)A") == 6
      assert Day09.part1("X(8x2)(3x3)ABCY") == 18
    end
  end

  describe "part2/1" do
    test "returns distance of first revisited location" do
      assert Day09.part2("(3x3)XYZ") == 9
      assert Day09.part2("X(8x2)(3x3)ABCY") == 20
      assert Day09.part2("(27x12)(20x12)(13x14)(7x10)(1x12)A") == 241920
      assert Day09.part2("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN") == 445
    end
  end
end
