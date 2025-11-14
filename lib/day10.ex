defmodule Bot do
  @enforce_keys [:bot_id, :low_to, :low_id, :high_to, :high_id]
  defstruct [:bot_id, :low_to, :low_id, :high_to, :high_id, values: []]
end

defmodule Aoc2016.Day10 do
  @value_regex ~r/value (?<val>\d+) goes to bot (?<bot_id>\d+)/
  @transfer_regex ~r/bot (?<bot_id>\d+) gives low to (?<low_to>\w+) (?<low_id>\d+) and high to (?<high_to>\w+) (?<high_id>\d+)/

  defp input do
    String.trim(File.read!("priv/inputs/day10.txt"))
  end

  def part1(), do: part1(input())

  def process_row(row) do
    cond do
      Regex.match?(@value_regex, row) -> {"value", Regex.named_captures(@value_regex, row)}
      true -> {"transfer", Regex.named_captures(@transfer_regex, row)}
    end
  end

  def populate_bots(bot_graph, row) do
    bot = Map.get(bot_graph, row["bot_id"])
    bot = struct!(bot, values: bot.values ++ [String.to_integer(row["val"])])

    Map.put(bot_graph, row["bot_id"], bot)
  end

  defp attempt_bot_transfer(graph, outputs, queue, "bot", bot_id, value) do
    to_bot = graph[bot_id]
    to_bot = struct!(to_bot, values: to_bot.values ++ [value])
    graph = Map.put(graph, bot_id, to_bot)

    queue =
      cond do
        length(to_bot.values) == 2 -> queue ++ [to_bot]
        true -> queue
      end

    {graph, queue, outputs}
  end

  defp attempt_bot_transfer(graph, outputs, queue, "output", output_id, value) do
    output = Map.get(outputs, output_id, 0)
    output = output + value
    outputs = Map.put(outputs, output_id, output)
    {graph, queue, outputs}
  end

  defp bfs(_graph, [], outputs) do
    outputs
  end

  defp bfs(graph, [node | rest], outputs) do
    {low, high} = Enum.sort(node.values) |> List.to_tuple()
    IO.inspect(node)
    IO.inspect({low, high})

    if {low, high} == {17, 61} do
      node.bot_id
    end

    {graph, rest, outputs} =
      attempt_bot_transfer(graph, outputs, rest, node.high_to, node.high_id, high)

    {graph, rest, outputs} =
      attempt_bot_transfer(graph, outputs, rest, node.low_to, node.low_id, low)

    bfs(graph, rest, outputs)
  end

  def get_bot_graph(input) do
    input =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&process_row(&1))

    bot_graph =
      input
      |> Enum.filter(fn x -> elem(x, 0) == "transfer" end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(%{}, fn row, graph ->
        bot = %Bot{
          bot_id: row["bot_id"],
          high_to: row["high_to"],
          high_id: row["high_id"],
          low_to: row["low_to"],
          low_id: row["low_id"]
        }

        Map.put(graph, row["bot_id"], bot)
      end)

    values =
      input
      |> Enum.filter(fn x -> elem(x, 0) == "value" end)
      |> Enum.map(&elem(&1, 1))

    Enum.reduce(values, bot_graph, fn row, bot_graph -> populate_bots(bot_graph, row) end)
  end

  def part1(input) do
    bot_graph = get_bot_graph(input)

    start = Map.filter(bot_graph, fn {_key, val} -> length(val.values) == 2 end) |> Map.values()
    bfs(bot_graph, start, %{})
  end

  def part2(), do: part2(input())

  def part2(input) do
    bot_graph = get_bot_graph(input)

    start = Map.filter(bot_graph, fn {_key, val} -> length(val.values) == 2 end) |> Map.values()
    outputs = bfs(bot_graph, start, %{})

    Enum.reduce(0..2, 1, fn i, prod ->
      val = outputs[Integer.to_string(i)]
      prod * val
    end)
  end
end
