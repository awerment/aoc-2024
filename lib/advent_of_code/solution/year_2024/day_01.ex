defmodule AdventOfCode.Solution.Year2024.Day01 do
  def part1(input) do
    String.split(input, "\n", trim: true)
    |> Stream.map(&Regex.split(~r/\s/, &1))
    |> Stream.map(fn [left, _, _, right] ->
      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.reduce({[], []}, fn {left, right}, {left_list, right_list} ->
      {[left | left_list], [right | right_list]}
    end)
    |> then(fn {left_list, right_list} -> [Enum.sort(left_list), Enum.sort(right_list)] end)
    |> Stream.zip()
    |> Stream.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  def part2(_input) do
  end
end
