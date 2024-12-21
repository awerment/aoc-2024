defmodule AdventOfCode.Solution.Year2024.Day08 do
  use AdventOfCode.Solution.SharedParse
  import Bitwise

  defstruct [:grid, :antennae]

  def parse(input) do
    {:ok, dimensions} = Agent.start_link(fn -> nil end)

    antennae =
      input
      |> String.split("\n", trim: true)
      |> tap(fn [l | _] = lines ->
        x = Enum.count(lines)
        y = String.length(l)
        Agent.update(dimensions, fn _ -> {x, y} end)
      end)
      |> Stream.with_index()
      |> Stream.flat_map(fn {line, x} ->
        line
        |> String.to_charlist()
        |> Stream.with_index()
        |> Stream.filter(fn {c, _y} -> c != ?. end)
        |> Enum.map(fn {c, y} -> {c, {x, y}} end)
      end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    grid = Agent.get(dimensions, &Function.identity/1)
    Agent.stop(dimensions)

    struct!(__MODULE__, grid: grid, antennae: antennae)
  end

  # skip the antenna itself and only take one valid location forward and backward
  def part1(state), do: solve(state, &(Stream.drop(&1, 1) |> Enum.take(1)))
  # keep antennae's location and all locations forward and backward
  def part2(state), do: solve(state, &Enum.to_list/1)

  defp solve(%{grid: grid, antennae: antennae}, consumer) do
    antennae
    |> Stream.flat_map(fn {_c, coords} ->
      coords = Enum.with_index(coords)

      # find antinodes for all unique pairs
      for({a, ai} <- coords, {b, bi} <- coords, ai < bi, do: {a, b})
      |> Enum.flat_map(fn {a, b} -> antinodes(a, b, delta(a, b), grid, consumer) end)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def delta({ax, ay}, {bx, by}), do: {bx - ax, by - ay}

  def antinodes(a, b, delta, grid, consumer) do
    Stream.concat([
      Stream.unfold(b, &step(&1, grid, fn p -> forward(p, delta) end)) |> consumer.(),
      Stream.unfold(a, &step(&1, grid, fn p -> backward(p, delta) end)) |> consumer.()
    ])
  end

  defp forward({x, y}, {dx, dy}), do: {x + dx, y + dy}
  defp backward({x, y}, {dx, dy}), do: {x - dx, y - dy}

  defp step({x, y}, _grid, _fun) when x < 0 or y < 0, do: nil
  defp step({x, y}, {gx, gy}, _fun) when x >= gx or y >= gy, do: nil
  defp step(coords, _grid, fun), do: {encode(coords), fun.(coords)}

  # optimize for uniqueness checks, grid is 50x50, so shifting by 6 bits is sufficient
  defp encode({x, y}), do: x <<< 6 ||| y
end
