defmodule AdventOfCode.Solution.Year2024.Day03Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day03

  setup do
    [
      input: AdventOfCode.Input.get!(3, 2024)
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 175_700_056
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 71_668_682
  end
end
