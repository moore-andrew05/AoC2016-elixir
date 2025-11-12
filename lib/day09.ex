defmodule Aoc2016.Day09 do
  @marker_regex ~r/\((?<capture>\d+)x(?<repetitions>\d+)\)/

  defp input do
    String.trim(File.read!("priv/inputs/day09.txt"))
  end

  def part1(), do: part1(input())

  def uncompress_sequence2(idx, builder_length, sequence, _) when idx > byte_size(sequence)do builder_length end
  def uncompress_sequence2(idx, builder_length, sequence, false) do
    builder_length + byte_size(binary_slice(sequence, idx..byte_size(sequence)))
  end
  
  def uncompress_sequence2(idx, builder_length, sequence, _) do
    curr_sequence = binary_slice(sequence, idx..byte_size(sequence))
    {next_idx, next_length, captures} = match_first_marker(curr_sequence)

    builder_length = builder_length + byte_size(binary_slice(curr_sequence, 0, next_idx))
    # From next_idx to next_legnth is our capture, which is not included in builder
    # We include our repetition after this
    start_capture = next_idx + next_length
    end_capture = start_capture + String.to_integer(captures["capture"])
    capture = binary_slice(curr_sequence, start_capture..end_capture-1)
    builder_length = builder_length + byte_size(capture |> String.duplicate(String.to_integer(captures["repetitions"])))
    has_next = Regex.match?(@marker_regex, binary_slice(curr_sequence, start_capture..byte_size(curr_sequence)))

    uncompress_sequence2(idx + start_capture, builder_length, sequence, has_next)


  end

  def uncompress_sequence(idx, builder, sequence, _) when idx > byte_size(sequence) do
    builder
  end

  def uncompress_sequence(idx, builder, sequence, false) do
    # TODO: WHERE IS INDEX
    builder <> binary_slice(sequence, idx..byte_size(sequence))
  end

  def uncompress_sequence(idx, builder, sequence, _) do
    curr_sequence = binary_slice(sequence, idx..byte_size(sequence))
    {next_idx, next_length, captures} = match_first_marker(curr_sequence)

    builder = builder <> binary_slice(curr_sequence, 0, next_idx)
    # From next_idx to next_legnth is our capture, which is not included in builder
    # We include our repetition after this
    start_capture = next_idx + next_length
    end_capture = start_capture + String.to_integer(captures["capture"])
    capture = binary_slice(curr_sequence, start_capture..end_capture-1)
    builder = builder <> (capture |> String.duplicate(String.to_integer(captures["repetitions"])))
    has_next = Regex.match?(@marker_regex, binary_slice(curr_sequence, end_capture..byte_size(curr_sequence)))

    uncompress_sequence(idx + end_capture, builder, sequence, has_next)


  end

  def match_first_marker(code_string) do
    {index, marker_length} =
      Regex.run(@marker_regex, code_string, capture: :first, return: :index) |> Enum.at(0)

    captures = Regex.named_captures(@marker_regex, code_string, capture: :first)
    {index, marker_length, captures}
  end

  def part1(input) do
    has_first = Regex.match?(@marker_regex, input)
    sequence = uncompress_sequence(0, "", input, has_first)
    sequence |> byte_size()
  end

  def part2(), do: part2(input())
  

  def part2(input) do
    has_first = Regex.match?(@marker_regex, input)
    uncompress_sequence2(0, 0, input, has_first)
  end
end
