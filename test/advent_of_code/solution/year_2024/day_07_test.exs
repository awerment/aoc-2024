defmodule AdventOfCode.Solution.Year2024.Day07Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day07

  setup do
    [input: AdventOfCode.Input.get!(7, 2024) |> parse()]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 2_314_935_962_622
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 401_477_450_831_495
  end
end
