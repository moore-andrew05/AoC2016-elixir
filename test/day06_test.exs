defmodule Aoc2016.Day06Test do
  use ExUnit.Case
  alias Aoc2016.Day06

  describe "part1/1" do
    test "Codepad part 1" do
      assert Day06.part1(File.read!("priv/inputs/day06_test.txt")) == "easter"
    end
  end

  describe "part2/1" do
    test "returns distance of first revisited location" do
      assert Day06.part2(File.read!("priv/inputs/day06_test.txt")) == "advent"
    end
  end
end


