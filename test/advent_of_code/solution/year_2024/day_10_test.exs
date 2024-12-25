defmodule AdventOfCode.Solution.Year2024.Day10Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day10

  setup do
    [input: AdventOfCode.Input.get!(10, 2024) |> parse()]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 698
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 1436
  end
end
