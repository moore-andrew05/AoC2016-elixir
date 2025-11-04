## Problem Thoughts
Conceptually very easy of course since is day 1. If I was doing in Python would take 5-10 minutes. 

## Elixir Thoughts
First time ever working with elixir so very rough. Especially part2 is a disaster. I can see the potential, will try to use the |> operator more in coming problems. A lot of time spent in docs learning what functions are actually available. 

Pretty good use case for AI, here is the cleaned up version of my part 2 code that was provided by Chat gipity:
```elixir
def part2(input) do
  steps = String.split(input, ", ")

  Enum.reduce_while(steps, {0, 0, 0, MapSet.new([{0, 0}])}, fn step, {dir, x, y, visited} ->
    {curr_dir, val} =
      case step do
        "R" <> val -> {dir + 1, val}
        "L" <> val -> {dir + 3, val}
      end

    val = String.to_integer(val)
    dir_solved = rem(curr_dir, 4)

    path =
      case dir_solved do
        0 -> Enum.map(1..val, fn i -> {x, y + i} end)
        1 -> Enum.map(1..val, fn i -> {x + i, y} end)
        2 -> Enum.map(1..val, fn i -> {x, y - i} end)
        3 -> Enum.map(1..val, fn i -> {x - i, y} end)
      end

    case Enum.find(path, &MapSet.member?(visited, &1)) do
      nil ->
        new_visited = Enum.reduce(path, visited, &MapSet.put(&2, &1))
        {newx, newy} = List.last(path)
        {:cont, {curr_dir, newx, newy, new_visited}}

      {hx, hy} ->
        {:halt, abs(hx) + abs(hy)}
    end
  end)
end
```
