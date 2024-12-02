defmodule AdventOfCode.Solution.Year2024.Day02Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day02

  setup do
    [
      input: AdventOfCode.Input.get!(2, 2024) |> parse()
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 442
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 493
  end
end
