defmodule AdventOfCode.Solution.Year2024.Day09Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day09

  setup do
    [input: AdventOfCode.Input.get!(9, 2024)]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 6_279_058_075_753
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 6_301_361_958_738
  end
end
