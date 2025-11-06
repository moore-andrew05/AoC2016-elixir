defmodule Aoc2016.Day03Test do
  use ExUnit.Case
  alias Aoc2016.Day03

  describe "part1/1" do
    test "Codepad part 1" do
      assert Day03.part1("ULL\nRRDDD\nLURDL\nUUUUD") == [1, 9, 8, 5]
    end
  end

  describe "part2/1" do
    test "returns distance of first revisited location" do
      assert Day03.part2("ULL\nRRDDD\nLURDL\nUUUUD") == ["5", "D", "B", "3"]
    end
  end
end

