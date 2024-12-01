defmodule AdventOfCode.Solution.Year2024.Day01 do
  use AdventOfCode.Solution.SharedParse

  @spec part1({list(integer()), list(integer())}) :: integer()
  def part1({left, right} = _input) do
    [Enum.sort(left), Enum.sort(right)]
    |> Stream.zip()
    |> Stream.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  @spec part2({list(integer()), list(integer())}) :: integer()
  def part2({left, right} = _input) do
    frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn num, acc ->
      acc + num * Map.get(frequencies, num, 0)
    end)
  end

  @impl AdventOfCode.Solution.SharedParse
  @spec parse(String.t()) :: {list(integer()), list(integer())}
  def parse(raw_input) do
    String.split(raw_input, "\n", trim: true)
    |> Stream.map(&Regex.split(~r/\s/, &1, trim: true))
    |> Stream.map(fn [left, right] ->
      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.unzip()
  end
end
