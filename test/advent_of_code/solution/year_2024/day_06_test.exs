defmodule AdventOfCode.Solution.Year2024.Day06Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day06

  setup do
    [
      input: AdventOfCode.Input.get!(6, 2024)
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 5516
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result
  end
end
