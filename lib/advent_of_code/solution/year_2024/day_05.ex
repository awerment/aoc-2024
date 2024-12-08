defmodule AdventOfCode.Solution.Year2024.Day05 do
  alias AdventOfCode.Solution.Year2024.Day05
  defstruct rules: %{}, updates: []

  def part1(input) do
    %{rules: rules, updates: updates} =
      input
      |> String.split("\n")
      |> Enum.reduce({:rules, %Day05{}}, fn
        "", {:rules, acc} ->
          {:updates, acc}

        line, {:rules, acc} ->
          line
          |> String.split("|", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> then(fn [a, b] ->
            {:rules,
             %Day05{
               acc
               | rules: Map.update(acc.rules, a, MapSet.new([b]), fn bs -> MapSet.put(bs, b) end)
             }}
          end)

        "", {:updates, acc} ->
          acc

        line, {:updates, acc} ->
          line
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> then(fn u -> {:updates, %Day05{acc | updates: [u | acc.updates]}} end)
      end)

    updates
    |> Enum.reduce(0, fn update, acc ->
      if valid_update?(Enum.reverse(update), rules) do
        acc + Enum.at(update, div(Enum.count(update), 2))
      else
        acc
      end
    end)
    |> IO.inspect()
  end

  defp valid_update?([], _rules), do: true

  defp valid_update?([page | rest], rules) do
    if MapSet.disjoint?(Map.get(rules, page), MapSet.new(rest)) do
      valid_update?(rest, rules)
    else
      false
    end
  end

  def part2(_input) do
  end
end
