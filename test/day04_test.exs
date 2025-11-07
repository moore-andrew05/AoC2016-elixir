defmodule Aoc2016.Day04Test do
  use ExUnit.Case
  alias Aoc2016.Day04

  describe "part1/1" do
    test "Codepad part 1" do
      assert Day04.part1("aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]") == 1514
    end
  end

  describe "part2/1" do
    test "returns distance of first revisited location" do
    end
  end
end

