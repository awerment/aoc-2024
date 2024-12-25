defmodule AdventOfCode.Solution.Year2024.Day10 do
  use AdventOfCode.Solution.SharedParse

  defstruct trailheads: [], grid: %{}

  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, x} ->
      String.splitter(line, "", trim: true)
      |> Stream.with_index()
      |> Stream.map(fn {height, y} ->
        {x, y, String.to_integer(height)}
      end)
    end)
    |> Enum.reduce(%__MODULE__{}, fn
      {x, y, 0}, %{trailheads: trailheads, grid: grid} = acc ->
        %{acc | trailheads: [{x, y} | trailheads], grid: Map.put(grid, {x, y}, 0)}

      {x, y, h}, %{grid: grid} = acc ->
        %{acc | grid: Map.put(grid, {x, y}, h)}
    end)
  end

  def part1(world) do
    world
    |> solve(&(Enum.uniq_by(&1, fn [{x, y} | _] -> {x, y} end) |> Enum.count()))
  end

  def part2(world) do
    world
    |> solve(&Enum.count/1)
  end

  defp solve(world, mapper) do
    world
    |> hikes()
    |> Enum.map(mapper)
    |> Enum.sum()
  end

  defp hikes(%{trailheads: trailheads, grid: grid}) do
    trailheads
    |> Enum.map(fn {x, y} ->
      1..9
      |> Enum.reduce([[{x, y}]], fn height, paths ->
        paths
        |> Enum.flat_map(fn [{x, y} | _rest] = path ->
          @directions
          |> Enum.map(fn {dx, dy} ->
            move = {x + dx, y + dy}

            if Map.get(grid, move, false) == height do
              [move | path]
            else
              nil
            end
          end)
          |> Enum.filter(&Function.identity/1)
        end)
      end)
    end)
  end
end
