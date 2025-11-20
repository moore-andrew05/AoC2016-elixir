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

# Keep for now maybe.
defmodule FloorState do
  @enforce_keys [:floors, :elevator_pos]
  defstruct [
    :floors,
    :elevator_pos,
    :depth
  ]
end

defmodule Aoc2016.Day11 do
  defp input do
    String.trim(File.read!("priv/inputs/day11.txt"))
  end

  defp input2 do
    String.trim(File.read!("priv/inputs/day11b.txt"))
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

  defp parse_items_from_regex_capture(capture, type) do
    capture
    |> Enum.reduce(MapSet.new(), fn x, items ->
      item = %Item{
        element: String.to_atom(x),
        type: type
      }

      MapSet.put(items, item)
    end)
  end

  defp parse_input_row(row) do
    generators =
      Regex.scan(~r/(?<generators>\w+) generator/, row, capture: :all_but_first)
      |> List.flatten()

    chips =
      Regex.scan(~r/(?<microchips>\w+)-compatible microchip/, row, capture: :all_but_first)
      |> List.flatten()

    chips = parse_items_from_regex_capture(chips, :chip)
    generators = parse_items_from_regex_capture(generators, :gen)

    MapSet.union(chips, generators)
  end

  # Keep this for now but will need heavy mods.
  def canonicalize_state(%FloorState{floors: floors_map, elevator_pos: elevator_pos}) do
    pairs =
      floors_map
      |> Enum.flat_map(fn {pos, items} ->
        Enum.map(items, fn %Item{element: element, type: type} -> {element, type, pos} end)
      end)

    groups =
      pairs
      |> Enum.group_by(fn {element, type, _floor} -> {element, type} end)
      |> Map.values()
      |> List.flatten()
      |> Enum.chunk_every(2)

    groups =
      groups
      |> Enum.reduce([], fn x, acc ->
        [h | t] = x
        t = List.first(t)
        {h, t} = {elem(h, 2), elem(t, 2)}
        [{t, h} | acc]
      end)
      |> Enum.sort()
      |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join() end)
      |> Enum.join()

    groups <> Integer.to_string(elevator_pos)
  end

  defp elevator_has_items_below?(%FloorState{floors: floors, elevator_pos: pos, depth: _}) do
    below = Enum.map(0..(pos - 1), &Map.get(floors, &1))
    Enum.any?(below, fn x -> not Enum.empty?(x) end)
  end

  defp chip_conflict?(floor) do
    elems =
      floor
      |> Enum.group_by(&{&1.element})
      |> Map.filter(fn {_key, val} -> length(val) == 1 end)
      |> Map.filter(fn {_key, val} -> List.first(val).type == :chip end)

    map_size(elems) > 0
  end

  defp valid_floor?(floor) do
    has_generator = Enum.any?(floor, fn x -> x.type == :gen end)

    case has_generator do
      false -> true
      true -> not chip_conflict?(floor)
    end
  end

  def is_final?(%FloorState{floors: floor_map}) do
    {_, floors_below_top} = Map.pop(floor_map, 3)

    floors_below_top
    |> Map.values()
    |> Enum.all?(&Enum.empty?(&1))
  end

  defp carry(curr_floor, popped_floors, pos, depth, items, direction) do
    offset =
      case direction do
        :up -> 1
        :down -> -1
      end

    {next_floor, other_floors} = Map.pop(popped_floors, pos + offset)
    next_floor_state = 
      case next_floor do
        nil -> MapSet.new(items)
        _ -> MapSet.union(next_floor, MapSet.new(items))
      end

    case valid_floor?(next_floor_state) do
      true ->
        new_state =
          other_floors
          |> Map.put(pos, curr_floor)
          |> Map.put(pos + offset, next_floor_state)

        new_state = %FloorState{
          floors: new_state,
          elevator_pos: pos + offset,
          depth: depth + 1
        }

        {:ok, new_state}

      false ->
        {:empty, nil}
    end
  end

  def get_next_states(possibilities, curr_floor, popped_floors, pos, depth, direction, memo) do
    Enum.reduce(possibilities, {memo, []}, fn carried, {_, states} ->
      curr_floor = MapSet.difference(curr_floor, MapSet.new(carried))

      if not valid_floor?(curr_floor) do
        {memo, states}
      else
        {valid, next_state} = carry(curr_floor, popped_floors, pos, depth, carried, direction)
        valid = valid == :ok

        case valid and not MapSet.member?(memo, canonicalize_state(next_state)) do
          true -> {MapSet.put(memo, canonicalize_state(next_state)), [next_state | states]}
          false -> {memo, states}
        end
      end
    end)
  end

  def set_to_list_safe(set) do
    case is_nil(set) do
      true -> []
      false -> MapSet.to_list(set)
    end
  end

  def search(queue, depth, prev_depth, states_searched, memo) do
    case :queue.out(queue) do
      {:empty, _} ->
        {:done, depth}

      {{:value, floor_state}, rest} ->
        prev_depth =
          case depth > prev_depth do
            true ->
              IO.puts("New depth of #{depth} reached!")
              IO.puts("#{states_searched} states searched")
              IO.puts("Size of memo: #{MapSet.size(memo)}")
              depth

            _ ->
              prev_depth
          end

        %FloorState{floors: floor_map, elevator_pos: pos, depth: depth} = floor_state

        if pos == 3 and is_final?(floor_state) do
          IO.puts("Found solution at depth #{depth}!")
        end

        {curr_floor, popped_state} = Map.pop(floor_map, pos)

        take_one = set_to_list_safe(curr_floor)
        take_two = RC.comb(2, take_one)
        take_one = Enum.map(take_one, &[&1])

        can_go_up = pos < 3
        can_go_down = pos > 0 and elevator_has_items_below?(floor_state)

        {memo, up_two_states} =
          cond do
            can_go_up ->
              get_next_states(
                take_two,
                curr_floor,
                popped_state,
                pos,
                depth,
                :up,
                memo
              )

            true ->
              {memo, []}
          end
        {memo, up_states} = 
          case up_two_states do
            [] -> get_next_states(take_one, curr_floor, popped_state, pos, depth, :up, memo)
            _ -> {memo, up_two_states}
              
          end

        {memo, down_states} =
          cond do
            can_go_down ->
              get_next_states(take_one, curr_floor, popped_state, pos, depth, :down, memo)

            true ->
              {memo, []}
          end

        queue =
          Enum.reduce(up_states, rest, fn x, acc ->
            :queue.in(x, acc)
          end)

        queue =
          Enum.reduce(down_states, queue, fn x, acc ->
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

    search(:queue.from_list([starting_state]), 0, 0, 0, MapSet.new())
  end

  def part2(), do: part2(input2())

  def part2(input) do
    data = process_input(input)

    starting_state = %FloorState{
      floors: data,
      elevator_pos: 0,
      depth: 0
    }

    search(:queue.from_list([starting_state]), 0, 0, 0, MapSet.new())
  end
end
