defmodule AdventOfCode.Solution.Year2024.Day11 do
  use AdventOfCode.Solution.SharedParse

  def parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input) do
    input |> solve(25)
  end

  def part2(input) do
    input |> solve(75)
  end

  defp solve(stones, blinks) do
    {:ok, memo} = Agent.start_link(fn -> %{} end)

    stones
    |> Task.async_stream(&branch([&1], blinks, memo))
    |> Stream.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp branch([_a], 0, _memo), do: 1
  defp branch([_a, _b], 0, _memo), do: 2

  defp branch([a], blink, memo) do
    case Agent.get(memo, fn m -> Map.get(m, {a, blink}) end) do
      nil ->
        val = branch(blink(a), blink - 1, memo)
        Agent.update(memo, fn m -> Map.put(m, {a, blink}, val) end)
        val

      val ->
        val
    end
  end

  defp branch([a, b], blink, memo),
    do: branch(blink(a), blink - 1, memo) + branch(blink(b), blink - 1, memo)

  defp blink(0), do: [1]
  defp blink(1), do: [2024]

  defp blink(n) do
    digits = Integer.digits(n)
    length = length(digits)

    case rem(length, 2) do
      0 ->
        digits
        |> Enum.split(div(length, 2))
        |> Tuple.to_list()
        |> Enum.map(&Integer.undigits/1)

      _ ->
        [n * 2024]
    end
  end
end
