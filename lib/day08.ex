defmodule Aoc2016.Day08 do
  @row_size 50
  @rect_regex ~r/rect (?<x>\d+)x(?<y>\d+)/
  @row_regex ~r/rotate row y=(?<y>\d+) by (?<n>\d+)/
  @col_regex ~r/rotate column x=(?<x>\d+) by (?<n>\d+)/

  defp input do
    String.trim(File.read!("priv/inputs/day08.txt"))
  end

  defp match_row(row) do
    cond do
      Regex.match?(@rect_regex, row) -> {"rect", Regex.named_captures(@rect_regex, row)}
      Regex.match?(@row_regex, row) -> {"row", Regex.named_captures(@row_regex, row)}
      Regex.match?(@col_regex, row) -> {"col", Regex.named_captures(@col_regex, row)}
    end
  end

  def transpose_board(board) do
    board
    |> Enum.map(&String.graphemes(&1))
    |> Enum.zip()
    |> Enum.map(fn x ->
      x
      |> Tuple.to_list()
      |> Enum.join()
    end)
  end

  defp rotate_row(row, n) do
    binary_slice(row, String.length(row) - n, @row_size) <>
      binary_slice(row, 0, String.length(row) - n)
  end

  def rotate_col_in_board(board, idx, n) do
    idx = String.to_integer(idx)
    n = String.to_integer(n)
    transposed = transpose_board(board)
    row = Enum.at(transposed, idx)
    n = rem(n, String.length(row))

    row = rotate_row(row, n)

    List.replace_at(transposed, idx, row)
    |> transpose_board()
  end

  def fill_rect_in_board(board, width, height) do
    width = String.to_integer(width)
    height = String.to_integer(height)

    Enum.reduce(0..(height - 1), board, fn x, curr_board ->
      row = Enum.at(curr_board, x)

      row =
        String.duplicate("#", width) <>
          binary_slice(row, width, @row_size)

      List.replace_at(curr_board, x, row)
    end)
  end

  @doc """
  Rotates row at index idx by n. Returns updated board.
  """
  def rotate_row_in_board(board, idx, n) do
    idx = String.to_integer(idx)
    n = String.to_integer(n)

    row = Enum.at(board, idx)
    n = rem(n, String.length(row))

    List.replace_at(board, idx, rotate_row(row, n))
  end

  defp operation_router(board, operation, values) do
    case operation do
      "rect" -> fill_rect_in_board(board, values["x"], values["y"])
      "row" -> rotate_row_in_board(board, values["y"], values["n"])
      "col" -> rotate_col_in_board(board, values["x"], values["n"])
    end
  end

  def simulate_board(input) do
      operations =
        input
        |> String.split("\n", trim: true)
        |> Enum.map(&match_row(&1))

      board = List.duplicate(String.duplicate("-", 50), 6)

      Enum.reduce(operations, board, fn op, curr_board ->
        {operation, values} = op
        operation_router(curr_board, operation, values)
      end)
  end

  def part1(), do: part1(input())

  def part1(input) do
    simulate_board(input)
    |> Enum.map(fn x ->
      x 
      |> String.graphemes()
      |> Enum.count(&(&1 == "#"))
    end)
    |> Enum.sum()
  end

  def part2(), do: part2(input())

  def part2(input) do
    simulate_board(input)
  end
end
