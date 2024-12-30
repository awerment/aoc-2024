defmodule AdventOfCode.Solution.Year2024.Day12 do
  use AdventOfCode.Solution.SharedParse

  def parse(input) do
    input
    |> String.split()
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, x} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {c, y} ->
        {c, x, y}
      end)
    end)
    |> Map.new(fn {c, x, y} -> {{x, y}, c} end)
    |> Stream.unfold(&next_region/1)
    |> Enum.to_list()
  end

  defp next_region(grid) when map_size(grid) == 0, do: nil

  @dirs [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
  defp next_region(grid) do
    Stream.resource(
      fn ->
        {coord, c} = Enum.at(grid, 0)
        {[coord], c, MapSet.new([coord]), Map.delete(grid, coord)}
      end,
      fn
        :stop ->
          {:halt, nil}

        {[], _c, region, grid} ->
          {[{region, grid}], :stop}

        {[{x, y} | next], c, region, grid} ->
          {next, region, grid} =
            @dirs
            |> Stream.map(fn {dx, dy} -> {x + dx, y + dy} end)
            |> Stream.filter(fn coord -> not MapSet.member?(region, coord) end)
            |> Stream.filter(fn coord -> Map.get(grid, coord) == c end)
            |> Enum.reduce({next, region, grid}, fn coord, {next, region, grid} ->
              {[coord | next], MapSet.put(region, coord), Map.delete(grid, coord)}
            end)

          {[], {next, c, region, grid}}
      end,
      fn _ -> :ok end
    )
    |> Enum.at(0)
  end

  def part1(regions), do: solve(regions, &(area(&1) * perimeter(&1)))
  def part2(regions), do: solve(regions, &(area(&1) * sides(&1)))

  defp solve(regions, mapper),
    do: regions |> Task.async_stream(mapper) |> Stream.map(&elem(&1, 1)) |> Enum.sum()

  defp area(region), do: MapSet.size(region)

  defp perimeter(region) do
    region
    |> Enum.reduce(0, fn {x, y}, acc ->
      @dirs
      |> Stream.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Stream.filter(fn coord -> not MapSet.member?(region, coord) end)
      |> Enum.count()
      |> then(fn n -> acc + n end)
    end)
  end

  @grid_size 150
  defp sides(region) do
    by_x = Enum.sort_by(region, fn {x, y} -> x * @grid_size + y end)
    by_y = Enum.sort_by(region, fn {x, y} -> y * @grid_size + x end)

    [
      # top
      sides(by_x, fn {x, y} -> MapSet.member?(region, {x - 1, y}) end, {0, 1}),
      # bottom
      sides(by_x, fn {x, y} -> MapSet.member?(region, {x + 1, y}) end, {0, 1}),
      # left
      sides(by_y, fn {x, y} -> MapSet.member?(region, {x, y - 1}) end, {1, 0}),
      # right
      sides(by_y, fn {x, y} -> MapSet.member?(region, {x, y + 1}) end, {1, 0})
    ]
    |> Enum.sum()
  end

  defp sides(sorted_region, skip?, distance) do
    sorted_region
    |> Enum.chunk_while(
      [],
      fn coord, acc ->
        case {coord, acc, skip?.(coord)} do
          {_coord, [], true} ->
            {:cont, []}

          {coord, [], false} ->
            {:cont, [coord]}

          {_coord, acc, true} ->
            {:cont, acc, []}

          {coord, [prev_coord | _], false} ->
            if dist(coord, prev_coord) == distance,
              do: {:cont, [coord | acc]},
              else: {:cont, acc, [coord]}
        end
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, acc, []}
      end
    )
    |> Enum.count()
  end

  defp dist({ax, ay}, {bx, by}), do: {abs(ax - bx), abs(ay - by)}
end
