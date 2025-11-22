defmodule Aoc2016.Day13 do
  require Integer

  defp input do
    1364
  end

  # x*x + 3*x + 2*x*y + y + y*y
  def calculate_position({x, y}, favorite_number) do
    step1 = x * x + 3 * x + 2 * x * y + y + y * y
    step2 = step1 + favorite_number

    step3 =
      Integer.digits(step2, 2)
      |> Enum.count(&(&1 == 1))

    cond do
      Integer.is_even(step3) -> :open
      Integer.is_odd(step3) -> :wall
    end
  end

  def generate_neighbors({x, y}) do
    cond do
      x < 1 and y < 1 -> [{0, 1}, {1, 0}]
      x < 1 -> [{0, 1}, {0, -1}, {1, 0}]
      y < 1 -> [{0, 1}, {1, 0}, {-1, 0}]
      true -> [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    end
  end

  defp attempt_move({x, y}, {dx, dy}, visited, favorite_number) do
    {nx, ny} = {x + dx, y + dy}

    valid = calculate_position({nx, ny}, favorite_number) == :open
    unseen = not MapSet.member?(visited, {nx, ny})

    case unseen and valid do
      false -> {:invalid, -1}
      true -> {:ok, {nx, ny}}
    end
  end

  def bfs(queue, {tx, ty}, visited, favorite_number, highest_depth, depth_limit, states_visited) do
    case :queue.out(queue) do
      {:empty, _} ->
        {:finished, -1}

      {{:value, {{_x, _y}, depth}}, _} when depth > depth_limit ->
        {:done, states_visited}

      {{:value, {{x, y}, depth}}, _} when {x, y} == {tx, ty} ->
        {:done, depth}

      {{:value, {{x, y}, depth}}, rest} ->
        highest_depth = if depth > highest_depth do
          IO.puts("New depth of #{depth} reached at position #{x}, #{y}.")
          depth
        else
          highest_depth
        end

        to_queue =
          generate_neighbors({x, y})
          |> Enum.reduce([], fn neighbor, acc ->
            case attempt_move({x, y}, neighbor, visited, favorite_number) do
              {:invalid, _} -> acc
              {:ok, new_pos} -> [new_pos | acc]
            end
          end)

        {rest, visited} = 
          Enum.reduce(to_queue, {rest, visited}, fn pos, {q, vis} ->
            {:queue.in({pos, depth + 1}, q), MapSet.put(vis, pos)}
          end)
        bfs(rest, {tx, ty}, visited, favorite_number, highest_depth, depth_limit, states_visited + 1)
    end


  end

  def part1(), do: part1(input())

  def part1(input) do
    target = {31, 39}
    q = :queue.new()
    q = :queue.in({{1, 1}, 0}, q)
    bfs(q, target, MapSet.new(), input, 0, 500, 0)
  end

  def part2(), do: part2(input())

  def part2(input) do
    target = {-1, -1}
    q = :queue.new()
    q = :queue.in({{1, 1}, 0}, q)
    bfs(q, target, MapSet.new(), input, 0, 49, 0)
  end
end
