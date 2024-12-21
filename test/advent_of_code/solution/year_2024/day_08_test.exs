defmodule AdventOfCode.Solution.Year2024.Day08Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day08

  setup do
    [input: AdventOfCode.Input.get!(8, 2024) |> parse()]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 371
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 1229
  end
end
