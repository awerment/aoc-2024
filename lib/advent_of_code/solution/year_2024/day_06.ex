defmodule AdventOfCode.Solution.Year2024.Day06 do
  use AdventOfCode.Solution.SharedParse

  defstruct guard: nil,
            obstacles: MapSet.new(),
            x: 0,
            y: 0

  def part1(state) do
    state
    |> Stream.unfold(fn
      %{guard: {{-1, _y}, _}} -> nil
      %{guard: {{_x, -1}, _}} -> nil
      %{guard: {{x, _y}, _}, x: x} -> nil
      %{guard: {{_x, y}, _}, y: y} -> nil
      state -> step(state)
    end)
    |> MapSet.new()
    |> MapSet.size()
  end

  defp step(%{guard: {{x, y}, {dx, dy}}} = state) do
    if MapSet.member?(state.obstacles, {x + dx, y + dy}) do
      {{x, y}, %{state | guard: {{x, y}, turn({dx, dy})}}}
    else
      {{x, y}, %{state | guard: {{x + dx, y + dy}, {dx, dy}}}}
    end
  end

  def part2(_input) do
  end

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, x} ->
      String.splitter(line, "", trim: true)
      |> Stream.with_index()
      |> Stream.map(fn {c, y} -> {{x, y}, c} end)
    end)
    |> Enum.reduce(%__MODULE__{}, fn {{x, y}, c}, acc ->
      case c do
        "#" -> Map.update!(acc, :obstacles, &MapSet.put(&1, {x, y}))
        "^" -> Map.put(acc, :guard, {{x, y}, {-1, 0}})
        _ -> acc
      end
      |> Map.update!(:x, &max(&1, x))
      |> Map.update!(:y, &max(&1, y))
    end)
    |> Map.update!(:x, &(&1 + 1))
    |> Map.update!(:y, &(&1 + 1))
  end

  defp turn({0, +1}), do: {+1, 0}
  defp turn({+1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, +1}
end
