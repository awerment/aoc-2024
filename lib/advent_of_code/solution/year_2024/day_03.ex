defmodule AdventOfCode.Solution.Year2024.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    Regex.scan(~r/mul\((\d+)\,(\d+)\)/, input)
    |> Enum.reduce(0, fn [_, l, r], acc -> acc + String.to_integer(l) * String.to_integer(r) end)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    Regex.scan(~r/mul\((\d+)\,(\d+)\)|don't()|do()/, input)
    |> Enum.reduce({:do, 0}, fn
      ["do" | _], {_switch, acc} -> {:do, acc}
      ["don't" | _], {_switch, acc} -> {:dont, acc}
      [_, l, r], {:do, acc} -> {:do, acc + String.to_integer(l) * String.to_integer(r)}
      _, {op, acc} -> {op, acc}
    end)
    |> elem(1)
  end
end
