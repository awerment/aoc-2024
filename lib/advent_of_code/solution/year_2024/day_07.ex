defmodule AdventOfCode.Solution.Year2024.Day07 do
  use AdventOfCode.Solution.SharedParse

  @impl AdventOfCode.Solution.SharedParse
  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> Enum.flat_map(&Function.identity/1)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(input) do
    solve(input, [&+/2, &*/2])
  end

  def part2(input) do
    solve(input, [&+/2, &*/2, &concat/2])
  end

  defp solve(input, ops) do
    input
    |> Enum.filter(fn [expected | [first_number | rest]] ->
      solveable?(expected, first_number, rest, ops)
    end)
    |> Enum.map(fn [expected | _] -> expected end)
    |> Enum.sum()
  end

  defp solveable?(expected, acc, [_next | _rest], _ops) when expected < acc, do: false
  defp solveable?(expected, expected, [], _ops), do: true
  defp solveable?(_expected, _result, [], _ops), do: false

  defp solveable?(expected, acc, [next | rest], ops) do
    Enum.any?(ops, fn op -> solveable?(expected, op.(acc, next), rest, ops) end)
  end

  defp concat(x, y) do
    String.to_integer("#{x}#{y}")
  end
end
