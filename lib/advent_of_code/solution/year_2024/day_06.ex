defmodule AdventOfCode.Solution.Year2024.Day06 do
  use AdventOfCode.Solution.SharedParse
  import Bitwise

  defstruct guard: nil,
            obstacles: MapSet.new(),
            x: 0,
            y: 0

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

  def part1(state) do
    state
    |> walk(&part1_emitter/1)
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(state) do
    %{guard: {guard_xy, _dir}, x: x, y: y} = state

    for x <- 0..(x - 1), y <- 0..(y - 1) do
      {x, y}
    end
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

  defp part1_emitter(%{guard: {{x, y}, _dir}}), do: x <<< 8 ||| y

  # correct
  # defp part2_emitter(%{guard: {{x, y}, {dx, dy}}}),
  #  do: (x + 1) <<< 24 ||| (y + 1) <<< 16 ||| (dx + 1) <<< 8 ||| dy + 1

  defp part2_emitter(%{guard: {{x, y}, dir}}) do
    bor(bor(dir(dir) <<< 16, x <<< 8), y)
  end

  defp walk(state, emit_fn) do
    state
    |> Stream.unfold(fn
      %{guard: {{-1, _y}, _}} -> nil
      %{guard: {{_x, -1}, _}} -> nil
      %{guard: {{x, _y}, _}, x: x} -> nil
      %{guard: {{_x, y}, _}, y: y} -> nil
      state -> step(state, emit_fn)
    end)
  end

  defp step(%{guard: {{x, y}, {dx, dy}}} = state, emit_fn) do
    if MapSet.member?(state.obstacles, {x + dx, y + dy}) do
      {emit_fn.(state), %{state | guard: {{x, y}, turn({dx, dy})}}}
    else
      {emit_fn.(state), %{state | guard: {{x + dx, y + dy}, {dx, dy}}}}
    end
  end

  defp turn({0, +1}), do: {+1, 0}
  defp turn({+1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, +1}

  defp dir({-1, 0}), do: 0
  defp dir({0, +1}), do: 1
  defp dir({+1, 0}), do: 2
  defp dir({0, -1}), do: 3
end
