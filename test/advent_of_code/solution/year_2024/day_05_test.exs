defmodule AdventOfCode.Solution.Year2024.Day05Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day05

  setup do
    [
      input: AdventOfCode.Input.get!(5, 2024) |> parse()
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 5747
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 5502
  end
end
