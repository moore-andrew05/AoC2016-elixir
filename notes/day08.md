## Problem Thoughts
Still easy conceptually, although how to actually do the row and column rotations takes some thoughts. 

## Elixir Thoughts
Looks good overall if a bit verbose. Main improvements in review:
- Using pattern matching for the router function
- Native binary approach for transposing the matrix since we are all ASCII. Didn't know bin_to_list or list_to_binary exist:
```elixir
rows
|> Enum.map(&:binary.bin_to_list/1)
|> Enum.zip()
|> Enum.map(fn t -> :erlang.list_to_binary(Tuple.to_list(t)) end)
```
