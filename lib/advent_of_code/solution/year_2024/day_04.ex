defmodule AdventOfCode.Solution.Year2024.Day04 do
  use AdventOfCode.Solution.SharedParse

  def part1(input) do
    %{
      grid: grid,
      num_lines: num_lines,
      max_line_index: max_line_index,
      num_columns: num_columns
    } = input

    Stream.resource(
      fn -> {0, 0} end,
      fn
        # this exit condition is... clunky
        # we run up the values for y, then hit the clause below with x = max_column_index
        # and increment _it_, thus landing here
        {^max_line_index, ^num_columns} ->
          {:halt, nil}

        # we increment y first, when it runs out of bounds, reset it and increment x
        {^num_lines, x} ->
          {[], {0, x + 1}}

        {y, x} ->
          # for every point, go right, go down, down-left and down-right
          # yes, starting with the third-last line, the points will run out of bounds
          # 🤷‍♂️
          {[
             [{y, x}, {y, x + 1}, {y, x + 2}, {y, x + 3}],
             [{y, x}, {y + 1, x}, {y + 2, x}, {y + 3, x}],
             [{y, x}, {y + 1, x + 1}, {y + 2, x + 2}, {y + 3, x + 3}],
             [{y, x}, {y + 1, x - 1}, {y + 2, x - 2}, {y + 3, x - 3}]
           ], {y + 1, x}}
      end,
      fn _ -> :ok end
    )
    |> Stream.map(&Enum.map(&1, fn coords -> Map.get(grid, coords) end))
    |> Enum.count(fn
      ["X", "M", "A", "S"] -> true
      ["S", "A", "M", "X"] -> true
      _ -> false
    end)
  end

  def part2(input) do
    %{
      grid: grid,
      max_line_index: max_line_index,
      max_column_index: max_column_index
    } = input

    for y <- 0..(max_line_index - 2), x <- 0..(max_column_index - 2) do
      [{y, x}, {y, x + 2}, {y + 1, x + 1}, {y + 2, x}, {y + 2, x + 2}]
    end
    |> Stream.map(fn x -> Enum.map(x, &Map.get(grid, &1)) end)
    |> Enum.count(fn
      ["M", "M", "A", "S", "S"] -> true
      ["S", "S", "A", "M", "M"] -> true
      ["S", "M", "A", "S", "M"] -> true
      ["M", "S", "A", "M", "S"] -> true
      _ -> false
    end)
  end

  def parse(raw_input) do
    lines = String.split(raw_input, "\n", trim: true)

    num_lines = Enum.count(lines)
    max_line_index = num_lines - 1
    num_columns = String.length(Enum.at(lines, 0))
    max_column_index = num_columns - 1

    grid =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        String.split(line, "", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {letter, x} -> {{y, x}, letter} end)
      end)
      |> Map.new()

    %{
      grid: grid,
      num_lines: num_lines,
      max_line_index: max_line_index,
      num_columns: num_columns,
      max_column_index: max_column_index
    }
  end
end
