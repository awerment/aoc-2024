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

  def part1(input), do: solve(input, [&+/2, &*/2])
  def part2(input), do: solve(input, [&+/2, &*/2, &concat/2])

  defp solve(input, ops) do
    Task.async_stream(input, fn [exp | [n | rest]] -> {exp, check(exp, n, rest, ops)} end)
    |> Stream.filter(fn {:ok, {_exp, solveable?}} -> solveable? end)
    |> Enum.reduce(0, fn {:ok, {exp, _}}, acc -> acc + exp end)
  end

  defp check(exp, acc, [_n | _rest], _ops) when exp < acc, do: false
  defp check(exp, exp, [], _ops), do: true
  defp check(_exp, _result, [], _ops), do: false
  defp check(exp, acc, [n | rest], ops), do: Enum.any?(ops, &check(exp, &1.(acc, n), rest, ops))

  defp concat(x, y), do: Integer.undigits(Integer.digits(x) ++ Integer.digits(y))
end
