defmodule AdventOfCode.Solution.Year2024.Day04Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day04

  setup do
    [
      input: AdventOfCode.Input.get!(4, 2024) |> parse()
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 2454
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 1858
  end
end
