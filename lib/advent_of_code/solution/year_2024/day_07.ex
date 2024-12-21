defmodule AdventOfCode.Solution.Year2024.Day07 do
  use AdventOfCode.Solution.SharedParse

  @impl AdventOfCode.Solution.SharedParse
  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(fn line ->
      # don't bother splitting expected result from numbers,
      # list's head is simply treated as the expected value
      Regex.scan(~r/\d+/, line)
      |> Enum.flat_map(&Function.identity/1)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # Part 1 and 2 differ only in the operators that are applied left-to-right,
  # so the `solve/2` function takes a list of the operators' function references
  def part1(input), do: solve(input, [&*/2, &+/2])
  def part2(input), do: solve(input, [&*/2, &concat/2, &+/2])

  defp solve(input, ops) do
    # `Task.async_stream/2` has a negative impact on part 1's runtime,
    # but boosts part 2's by a factor of ~4 on my machine

    # Kick off the check function by matching on expected result, first number and rest.
    # Since check returns a boolean and we still need the expected result... tuples it is.
    Task.async_stream(input, fn [exp | [n | rest]] -> {exp, check(exp, n, rest, ops)} end)
    |> Stream.filter(fn {:ok, {_exp, solveable?}} -> solveable? end)
    |> Enum.reduce(0, fn {:ok, {exp, _}}, acc -> acc + exp end)
  end

  # Accumulated value so far is already greater than expected result
  # -> bail
  defp check(exp, acc, _numbers, _ops) when exp < acc, do: false

  # Values are matched once, so this effectively checks that acc == exp and we have no numbers left
  # -> we have a winner
  defp check(exp, exp, [], _ops), do: true

  # We ran out of numbers, but the accumulated value is different from the expected result
  # (otherwise the clause above would match)
  # -> no dice
  defp check(_exp, _result, [], _ops), do: false

  # Recursive check for all operators: apply operator on accumulator and next number,
  # recurse with rest of the list.
  # Enum.any?/2 does exit early, so not worried too much about the non-concurrent nature of it
  defp check(exp, acc, [n | rest], ops), do: Enum.any?(ops, &check(exp, &1.(acc, n), rest, ops))

  defp concat(x, y), do: x * fac(y) + y

  defp fac(n) when n < 10, do: 10
  defp fac(n) when n < 100, do: 100
  defp fac(_n), do: 1000
end
