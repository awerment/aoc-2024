defmodule AdventOfCode.Solution.Year2024.Day01 do
  def part1(input) do
    input
    |> to_integer_lists()
    |> then(fn {left_list, right_list} -> [Enum.sort(left_list), Enum.sort(right_list)] end)
    |> Stream.zip()
    |> Stream.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  def part2(input) do
    {left, right} = to_integer_lists(input)

    frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn num, acc ->
      acc + num * Map.get(frequencies, num, 0)
    end)
  end

  defp to_integer_lists(input) do
    String.split(input, "\n", trim: true)
    |> Stream.map(&Regex.split(~r/\s/, &1, trim: true))
    |> Stream.map(fn [left, right] ->
      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.unzip()
  end
end
