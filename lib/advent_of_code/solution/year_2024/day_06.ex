defmodule AdventOfCode.Solution.Year2024.Day06 do
  use AdventOfCode.Solution.SharedParse
  import Bitwise

  defstruct guard: nil,
            obstacles: nil,
            x: 0,
            y: 0

  def parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, x} ->
      String.splitter(line, "", trim: true)
      |> Stream.with_index()
      |> Stream.map(fn {c, y} -> {x, y, c} end)
    end)
    |> Enum.reduce(%__MODULE__{obstacles: []}, fn {x, y, c}, acc ->
      case c do
        "#" -> Map.update!(acc, :obstacles, &[{x, y} | &1])
        "^" -> Map.put(acc, :guard, {{x, y}, {-1, 0}})
        _ -> acc
      end
      |> Map.update!(:x, &max(&1, x))
      |> Map.update!(:y, &max(&1, y))
    end)
    # final x and y needed are the ones that are out of bounds
    |> Map.update!(:x, &(&1 + 1))
    |> Map.update!(:y, &(&1 + 1))
    |> Map.update!(:obstacles, &MapSet.new/1)
  end

  def part1(state) do
    state
    |> walk(&part1_emitter/1)
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(state) do
    %{guard: {guard_xy, _dir}, x: x, y: y} = state

    # generate a list of coordinates for the whole grid,
    # subtract existint obstacles and the starting location of the guard
    # then, for each of the remaining coordinates:
    # - place an obstacle
    # - walk the guard (emitting x, y, and guard's direction)
    # - an occurance of the same coordinate with the same location means there's a loop

    # subtract 1 here again to account for the out of bounds shift in parse
    full_grid(x - 1, y - 1)
    |> MapSet.new()
    |> MapSet.difference(state.obstacles)
    |> MapSet.delete(guard_xy)
    |> Task.async_stream(fn xy ->
      state
      |> Map.update!(:obstacles, &MapSet.put(&1, xy))
      |> walk(&part2_emitter/1)
      |> Enum.reduce_while({false, MapSet.new()}, fn g, {_loop, set} ->
        if MapSet.member?(set, g) do
          {:halt, {true, set}}
        else
          {:cont, {false, MapSet.put(set, g)}}
        end
      end)
      |> then(fn {loop, _map} -> loop end)
    end)
    |> Stream.filter(fn {:ok, f} -> f end)
    |> Enum.count()
  end

  defp part1_emitter(%{guard: {{x, y}, _dir}}) do
    # to speed up uniqueness checks, turn x and y into a 16 bit value
    x <<< 8 ||| y
  end

  defp part2_emitter(%{guard: {{x, y}, dir}}) do
    # to speed up uniqueness checks, turn x, y and direction into an 18 bit value
    dir(dir) <<< 16 ||| x <<< 8 ||| y
  end

  defp full_grid(x, y), do: for(x <- 0..x, y <- 0..y, do: {x, y})

  defp walk(state, emit_fn) do
    state
    |> Stream.unfold(fn
      # stop walking when guard steps out of bounds (0..(x - 1))
      %{guard: {{-1, _y}, _}} -> nil
      %{guard: {{_x, -1}, _}} -> nil
      %{guard: {{x, _y}, _}, x: x} -> nil
      %{guard: {{_x, y}, _}, y: y} -> nil
      state -> step(state, emit_fn)
    end)
  end

  defp step(%{guard: {{x, y}, {dx, dy}}} = state, emit_fn) do
    ahead = {x + dx, y + dy}
    # look ahead for obstacles in walking direction
    if MapSet.member?(state.obstacles, ahead) do
      # if there is an obstacle, remain in place and turn
      # note: yes, this means when turning, the same coordinates are emitted twice
      # couldn't be bothered to optimise this fact away, MapSet will take care of it
      {emit_fn.(state), %{state | guard: {{x, y}, turn({dx, dy})}}}
    else
      # if there is no obstacle, step ahead and keep direction
      {emit_fn.(state), %{state | guard: {ahead, {dx, dy}}}}
    end
  end

  # x = 0, y = 0 is the top-left corner
  defp turn({0, +1}), do: {+1, 0}
  defp turn({+1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, +1}

  # for part 2: reduce direction to 2-bit value
  defp dir({-1, 0}), do: 0
  defp dir({0, +1}), do: 1
  defp dir({+1, 0}), do: 2
  defp dir({0, -1}), do: 3
end
