defmodule AdventOfCode.Solution.Year2024.Day12Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day12

  setup do
    [input: AdventOfCode.Input.get!(12, 2024) |> parse()]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 1_483_212
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 897_062
  end
end
