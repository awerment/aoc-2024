defmodule AdventOfCode.Solution.Year2024.Day11Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day11

  setup do
    [
      input: AdventOfCode.Input.get!(11, 2024) |> parse()
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 186_175
  end

  @tag timeout: :infinity
  test "part2", %{input: input} do
    result = part2(input)

    assert result == 220_566_831_337_810
  end
end
