defmodule Aoc2016.Day07Test do
  use ExUnit.Case
  alias Aoc2016.Day07

  describe "part1/1" do
    test "IPv7 Valid check" do
      assert Day07.is_ip_valid("abba[mnop]qrst") == true
      assert Day07.is_ip_valid("abcd[bddb]xyyx") == false
      assert Day07.is_ip_valid("aaaa[qwer]tyui") == false
      assert Day07.is_ip_valid("ioxxoj[asdfgh]zxcvbn") == true
    end
  end

  describe "part2/1" do
    test "returns distance of first revisited location" do
      assert Day07.part2(File.read!("priv/inputs/day06_test.txt")) == "advent"
    end
  end
end



