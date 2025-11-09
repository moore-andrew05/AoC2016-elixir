## Problem Thoughts
Conceptually everything still easy

## Elixir Thoughts
I think this was one of my rougher solutions. Really tested my ability to program in a functional paradigm and I don't know that it went particularly well. I liked the regex, but I think the string chunking was pretty bad. This is probably the most significant improvement that came up in review: 

```elixir
def has_abba?(<<a, b, b, a, _::binary>>) when a != b, do: true
def has_abba?(<<_::binary-size(1), rest::binary>>), do: has_abba?(rest)
def has_abba?(_), do: false
```

Outside of this, I think my helpers are pretty scattered, and I am still getting used to when to split things up vs just slapping a reduce on it. Still a working and fast solution. 


