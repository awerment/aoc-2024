defmodule AdventOfCode.Solution.Year2024.Day01Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day01

  setup do
    [
      input: AdventOfCode.Input.get!(1, 2024)
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 765_748
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result
  end
end
