defmodule AdventOfCode.Solution.Year2024.Day10 do
  use AdventOfCode.Solution.SharedParse

  defstruct trailheads: [], peaks: [], grid: %{}, graph: nil

  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  def parse(input) do
    world =
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

        {x, y, 9}, %{peaks: peaks, grid: grid} = acc ->
          %{acc | peaks: [{x, y} | peaks], grid: Map.put(grid, {x, y}, 9)}

        {x, y, h}, %{grid: grid} = acc ->
          %{acc | grid: Map.put(grid, {x, y}, h)}
      end)

    graph = :digraph.new([:acyclic])

    world.grid
    |> Enum.each(fn {{x, y}, h} ->
      :digraph.add_vertex(graph, {x, y})

      @directions
      |> Stream.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Stream.map(fn coords -> {coords, Map.get(world.grid, coords, -10)} end)
      |> Stream.filter(fn {_coords, dh} -> dh - h == 1 end)
      |> Enum.each(fn {coords, _hd} ->
        :digraph.add_vertex(graph, coords)
        :digraph.add_edge(graph, {x, y}, coords)
      end)
    end)

    %__MODULE__{world | graph: graph}
  end

  def part1(%{trailheads: trailheads, peaks: peaks, graph: graph}) do
    for {tx, ty} = t <- trailheads,
        {px, py} = p <- peaks,
        abs(tx - px) + abs(ty - py) < 10 do
      {t, p}
    end
    |> Stream.filter(fn {t, p} -> :digraph.get_path(graph, t, p) end)
    |> Enum.count()
  end

  def part2(%{trailheads: trailheads, peaks: peaks, graph: graph}) do
    for {tx, ty} = t <- trailheads,
        {px, py} = p <- peaks,
        abs(tx - px) + abs(ty - py) < 10 do
      {t, p}
    end
    |> Stream.map(fn {t, p} -> :digraph.get_path(graph, t, p) end)
    |> Stream.filter(&Function.identity/1)
    |> Stream.map(fn [trailhead, _1, _2, _3, _4, _5, _6, _7, _8, peak] ->
      Stream.resource(
        fn -> [[trailhead]] end,
        fn
          :stop ->
            {:halt, :ok}

          [[_1, _2, _3, _4, _5, _6, _7, _8, _9] | _] = paths ->
            {paths, :stop}

          paths ->
            paths
            |> Enum.flat_map(fn [v | _rest] = path ->
              :digraph.out_neighbours(graph, v)
              |> Enum.filter(fn n -> :digraph.get_short_path(graph, n, peak) end)
              |> Enum.map(fn n -> [n | path] end)
            end)
            |> then(&{[], &1})
        end,
        fn _ -> :ok end
      )
      |> Enum.count()
    end)
    |> Enum.sum()
  end
end
