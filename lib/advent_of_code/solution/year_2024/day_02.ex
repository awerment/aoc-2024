defmodule AdventOfCode.Solution.Year2024.Day02 do
  use AdventOfCode.Solution.SharedParse

  @spec part2(list(list(integer()))) :: integer()
  def part1(input) do
    input
    |> Enum.filter(&levels_safe?/1)
    |> Enum.count()
  end

  @spec part2(list(list(integer()))) :: integer()
  def part2(input) do
    input
    |> Enum.filter(fn levels ->
      levels
      |> List.duplicate(Enum.count(levels))
      |> Enum.with_index()
      |> Enum.map(fn {levels, index} -> List.delete_at(levels, index) end)
      |> then(fn list_of_levels -> [levels | list_of_levels] end)
      |> Enum.any?(&levels_safe?/1)
    end)
    |> Enum.count()
  end

  @impl AdventOfCode.Solution.SharedParse
  @spec parse(String.t()) :: list(list(integer()))
  def parse(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
  end

  defp levels_safe?(levels) do
    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [one, two] -> one - two end)
    |> then(fn diffs ->
      Enum.all?(diffs, &(&1 > 0 and &1 < 4)) or Enum.all?(diffs, &(&1 < 0 and &1 > -4))
    end)
  end
end
