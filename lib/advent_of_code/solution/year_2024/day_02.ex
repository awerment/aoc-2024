defmodule AdventOfCode.Solution.Year2024.Day02 do
  def part1(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
    |> Enum.filter(fn list ->
      diffs =
        list
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [one, two] -> one - two end)

      Enum.all?(diffs, &(&1 > 0 and &1 < 4)) or Enum.all?(diffs, &(&1 < 0 and &1 > -4))
    end)
    |> Enum.count()
  end

  def part2(_input) do
  end
end
