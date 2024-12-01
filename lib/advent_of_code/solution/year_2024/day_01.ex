defmodule AdventOfCode.Solution.Year2024.Day01 do
  use AdventOfCode.Solution.SharedParse

  @spec part1({list(integer()), list(integer())}) :: integer()
  def part1({left, right} = _input) do
    Enum.zip(Enum.sort(left), Enum.sort(right))
    |> Enum.map(fn {left, right} -> abs(left - right) end)
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
    raw_input
    |> String.split()
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Stream.map(fn [left, right] -> {left, right} end)
    |> Enum.unzip()
  end
end
