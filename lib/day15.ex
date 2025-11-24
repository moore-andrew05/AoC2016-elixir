defmodule Disc do
  @string_parse_regex ~r/Disc #(?<disc_num>\d+) has (?<rotor_size>\d+) positions; at time=0, it is at position (?<initial_pos>\d+)./
  @enforce_keys [:num, :size, :initial_pos]
  defstruct [
    :num,
    :size,
    :initial_pos
  ]

  def new_from_string(s) do
    extracted_vals = Regex.named_captures(@string_parse_regex, s)

    %__MODULE__{
      num: String.to_integer(extracted_vals["disc_num"]),
      size: String.to_integer(extracted_vals["rotor_size"]),
      initial_pos: String.to_integer(extracted_vals["initial_pos"])
    }
  end

  def get_first_valid(%Disc{num: num, size: size, initial_pos: initial_pos}) do
    size - rem(initial_pos + num, size)
  end

  def is_valid_at_time_t?(disc, t) do
    first = __MODULE__.get_first_valid(disc)

    cond do
      first > t -> false
      rem(t - first, disc.size) == 0 -> true
      true -> false
    end
  end
end

defmodule Aoc2016.Day15 do
  defp input do
    String.trim(File.read!("priv/inputs/day15.txt"))
  end
  defp input2 do
    String.trim(File.read!("priv/inputs/day15b.txt"))
  end

  def part1(), do: part1(input())

  def part1(input) do
    discs =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&Disc.new_from_string(&1))

    [first | rest] = discs

    firstfirst = Disc.get_first_valid(first)

    Stream.iterate(firstfirst, &(&1 + first.size))
    |> Enum.reduce_while(false, fn x, _found ->
      found = Enum.all?(rest, &Disc.is_valid_at_time_t?(&1, x))

      if found do
        {:halt, x}
      else
        {:cont, found}
      end
    end)
  end

  def part2(), do: part2(input2())

  def part2(input) do
    part1(input)
  end
end
