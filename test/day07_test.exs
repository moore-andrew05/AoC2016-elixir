defmodule Aoc2016.Day07Test do
  use ExUnit.Case
  alias Aoc2016.Day07

  describe "part1/1" do
    test "IPv7 Valid check" do
      assert Day07.ipv7_valid?("abba[mnop]qrst") == true
      assert Day07.ipv7_valid?("abcd[bddb]xyyx") == false
      assert Day07.ipv7_valid?("aaaa[qwer]tyui") == false
      assert Day07.ipv7_valid?("ioxxoj[asdfgh]zxcvbn") == true
    end
  end

  describe "part2/1" do
      assert Day07.ipv7_supports_ssl?("aba[bab]xyz") == true
      assert Day07.ipv7_supports_ssl?("xyx[xyx]xyx") == false
      assert Day07.ipv7_supports_ssl?("aaa[kek]eke") == true
      assert Day07.ipv7_supports_ssl?("zazbz[bzb]cdb") == true
    test "returns distance of first revisited location" do
    end
  end
end



