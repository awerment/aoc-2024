defmodule AdventOfCode.Solution.Year2024.Day05 do
  use AdventOfCode.Solution.SharedParse

  alias AdventOfCode.Solution.Year2024.Day05
  defstruct rules: %{}, updates: []

  def parse(raw_input) do
    raw_input
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
  end

  def part1(%Day05{rules: rules, updates: updates}) do
    updates
    |> Enum.reduce(0, fn update, acc ->
      if valid_update?(Enum.reverse(update), rules) do
        acc + Enum.at(update, div(Enum.count(update), 2))
      else
        acc
      end
    end)
  end

  def part2(%Day05{rules: rules, updates: updates}) do
    updates
    |> Stream.map(&Enum.reverse/1)
    |> Stream.reject(fn update -> valid_update?(update, rules) end)
    |> Stream.map(fn update -> fix_update([], update, rules) end)
    |> Enum.reduce(0, fn update, acc -> acc + Enum.at(update, div(Enum.count(update), 2)) end)
  end

  defp valid_update?([], _rules), do: true

  defp valid_update?([page | rest], rules) do
    if MapSet.disjoint?(Map.get(rules, page), MapSet.new(rest)) do
      valid_update?(rest, rules)
    else
      false
    end
  end

  defp fix_update(front, [], rules) do
    if valid_update?(front, rules), do: front, else: fix_update([], front, rules)
  end

  defp fix_update(front, [page | rest], rules) do
    page_rules = Map.get(rules, page)
    move_keep = Enum.group_by(rest, &MapSet.member?(page_rules, &1))

    Enum.concat([front, Map.get(move_keep, true, []), [page]])
    |> fix_update(Map.get(move_keep, false, []), rules)
  end
end
