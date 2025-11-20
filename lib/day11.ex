defmodule RC do
  def comb(0, _), do: [[]]
  def comb(_, []), do: []

  def comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end
end

# Attempt 2: We keep this for now.
defmodule Item do
  @enforce_keys [:element, :type]
  defstruct [
    :element,
    :type
  ]
end

defmodule FloorState do
  @enforce_keys [:floors, :elevator_pos]
  defstruct [
    :floors,
    :elevator_pos,
    :depth
  ]
end

defmodule Aoc2016.Day11 do
  @elements [:strontium, :plutonium, :thulium, :ruthenium]

  defp input do
    String.trim(File.read!("priv/inputs/day11.txt"))
  end

  def start_memo do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  defp parse_input_row(row) do
    generators =
      Regex.scan(~r/(?<generators>\w+) generator/, row, capture: :all_but_first)
      |> List.flatten()

    chips =
      Regex.scan(~r/(?<microchips>\w+)-compatible microchip/, row, capture: :all_but_first)
      |> List.flatten()

    generators =
      generators
      |> Enum.reduce(MapSet.new(), fn x, gens ->
        item = %Item{
          element: String.to_atom(x),
          type: :gen
        }

        MapSet.put(gens, item)
      end)

    chips =
      chips
      |> Enum.reduce(MapSet.new(), fn x, chips ->
        item = %Item{
          element: String.to_atom(x),
          type: :chip
        }

        MapSet.put(chips, item)
      end)

    %Floor{
      items: MapSet.union(chips, generators)
    }
  end

def canonicalize_state(%FloorState{floors: floors_map, elevator_pos: elevator_pos}) do
  # build list of {gen_floor, chip_floor} for each element
  pairs =
    floors_map
    |> Enum.flat_map(fn {floor_idx, %Floor{items: items}} ->
      Enum.map(items, fn %Item{element: el, type: ty} -> {el, ty, floor_idx} end)
    end)
    |> Enum.group_by(fn {el, _ty, _f} -> el end)
    |> Enum.map(fn {_el, items} ->
      gen_floor =
        items
        |> Enum.find_value(fn
          {_, :gen, f} -> f
          _ -> nil
        end)

      chip_floor =
        items
        |> Enum.find_value(fn
          {_, :chip, f} -> f
          _ -> nil
        end)

      {gen_floor, chip_floor}
    end)

  # collect all used floor indices (from pairs and elevator), sort and compress -> new indices 0..n
  used =
    (pairs |> Enum.flat_map(fn {g, c} -> [g, c] end)) ++ [elevator_pos]
    |> Enum.uniq()
    |> Enum.sort()

  remap = Enum.with_index(used) |> Enum.into(%{}, fn {old, idx} -> {old, idx} end)

  # remap pairs and elevator, sort pairs to remove element identity
  remapped_pairs =
    pairs
    |> Enum.map(fn {g, c} -> {Map.fetch!(remap, g), Map.fetch!(remap, c)} end)
    |> Enum.sort()

  remapped_elevator = Map.fetch!(remap, elevator_pos)

  # final canonical key: tuple with elevator then tuple-of-pairs
  {remapped_elevator, List.to_tuple(remapped_pairs)}
end

  defp elevator_has_items_below?(%FloorState{floors: floors, elevator_pos: pos, depth: _}) do
    below = Enum.map(0..(pos - 1), &Map.get(floors, &1))
    Enum.any?(below, fn x -> not Enum.empty?(x.items) end)
  end

  defp process_input(input) do
    {_, {res, _}} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map_reduce({%{}, 0}, fn line, {acc, idx} ->
        {line, {Map.put(acc, idx, parse_input_row(line)), idx + 1}}
      end)

    res
  end

  defp valid_floor?(floor) do
    has_generator = Enum.any?(floor.items, fn x -> x.type == :gen end)

    elems =
      floor.items
      |> Enum.group_by(&{&1.element})
      |> Map.filter(fn {_key, val} -> length(val) == 1 end)
      |> Map.filter(fn {_key, val} -> List.first(val).type == :chip end)

    if map_size(elems) > 0 and has_generator do
      false
    else
      true
    end
  end

  def is_final?(floor_state) do
    {_, floors} = Map.pop(floor_state.floors, 3)

    floors
    |> Map.values()
    |> Enum.all?(&Enum.empty?(&1.items))
  end

  def search(queue, depth, prev_depth, states_searched, memo) do
    if rem(states_searched, 1000) == 0 do
      IO.puts("Searched #{states_searched} states")
    end

    prev_depth =
      if depth > prev_depth do
        IO.puts("Reached depth #{depth}!")
        depth
      else
        prev_depth
      end

    case :queue.out(queue) do
      {:empty, _} ->
        {:done, depth}

      {{:value, floor_state}, rest} ->
        # Agent.update(__MODULE__, fn state -> MapSet.put(state, {floor_state.floors, floor_state.elevator_pos}) end)
        %FloorState{floors: floors, elevator_pos: pos, depth: depth} = floor_state
        memo = MapSet.put(memo, canonicalize_state(floor_state))

        if pos == 3 and is_final?(floor_state) do
          depth
        end

        {curr_floor, popped_state} = Map.pop(floors, pos)

        possibilities =
          Enum.map(curr_floor.items, &[&1]) ++ RC.comb(2, MapSet.to_list(curr_floor.items))

        states =
          Enum.reduce(possibilities, [], fn x, states ->
            removed = %Floor{items: MapSet.difference(curr_floor.items, MapSet.new(x))}

            if not valid_floor?(removed) do
              states
            end

            states =
              if pos == 3 do
                states
              else
                {up, no_floors} = Map.pop(popped_state, pos + 1)
                up_state = %Floor{items: MapSet.union(up.items, MapSet.new(x))}

                if valid_floor?(up_state) do
                  new_state =
                    no_floors
                    |> Map.put(pos, removed)
                    |> Map.put(pos + 1, up_state)

                  new_state = %FloorState{
                    floors: new_state,
                    elevator_pos: pos + 1,
                    depth: depth + 1
                  }

                  [new_state | states]
                else
                  states
                end
              end

            states =
              if pos == 0 or (pos > 0 and not elevator_has_items_below?(floor_state)) do
                states
              else
                {down, no_floors} = Map.pop(popped_state, pos - 1)
                down_state = %Floor{items: MapSet.union(down.items, MapSet.new(x))}

                if valid_floor?(down_state) do
                  new_state =
                    no_floors
                    |> Map.put(pos, removed)
                    |> Map.put(pos - 1, down_state)

                  new_state = %FloorState{
                    floors: new_state,
                    elevator_pos: pos - 1,
                    depth: depth + 1
                  }

                  [new_state | states]
                else
                  states
                end
              end

            states
          end)

        queue_addition =
          Enum.reduce(states, [], fn x, queue ->
            if MapSet.member?(memo, canonicalize_state(x)) do
              queue
            else
              [x | queue]
            end
          end)

        queue =
          Enum.reduce(queue_addition, rest, fn x, acc ->
            :queue.in(x, acc)
          end)

        search(queue, depth, prev_depth, states_searched + 1, memo)
    end
  end

  def part1(), do: part1(input())

  def part1(input) do
    data =
      process_input(input)

    starting_state = %FloorState{
      floors: data,
      elevator_pos: 0,
      depth: 0
    }

    starting_state
    # {:ok, pid} = start_memo()
    search(:queue.from_list([starting_state]), 0, 0, 0, MapSet.new())
  end

  def part2(), do: part2(input())

  def part2(input) do
  end
end
