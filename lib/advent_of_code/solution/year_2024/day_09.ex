defmodule AdventOfCode.Solution.Year2024.Day09 do
  defmodule One do
    def split(input) do
      Stream.resource(
        fn -> {:file, 0, String.split(input, "", trim: true)} end,
        fn
          {_, _, ["\n"]} -> {:halt, nil}
          {:file, id, [n | rest]} -> {file_block(id, n), {:space, id + 1, rest}}
          {:space, id, [n | rest]} -> {space_block(n), {:file, id, rest}}
        end,
        fn _ -> :ok end
      )
      |> Stream.with_index()
      |> Enum.to_list()
    end

    defp file_block(id, n) do
      Stream.duplicate(id, String.to_integer(n))
    end

    defp space_block(n) do
      Stream.duplicate(:space, String.to_integer(n))
      |> Enum.to_list()
    end

    def compact(compacted, [], r) do
      (compacted ++ Enum.map(r, &elem(&1, 0)))
      |> Enum.reverse()
    end

    def compact(compacted, l, []) do
      Enum.reverse(compacted)
      |> Enum.concat(Enum.map(l, &elem(&1, 0)))
    end

    def compact(compacted, [{l, l_idx} | _l_rest], [{_r, r_idx} | _r_rest])
        when l_idx == r_idx do
      [l | compacted]
      |> Enum.reverse()
    end

    def compact(compacted, l, [{:space, _r_idx} | r_rest]) do
      compact(compacted, l, r_rest)
    end

    def compact(compacted, [{:space, _l_idx} | l_rest], [{r, _r_idx} | r_rest]) do
      compact([r | compacted], l_rest, r_rest)
    end

    def compact(compacted, [{l, _l_idx} | l_rest], r) do
      compact([l | compacted], l_rest, r)
    end

    def checksum(blocks) do
      blocks
      |> Stream.with_index()
      |> Stream.map(fn {n, i} -> n * i end)
      |> Enum.sum()
    end
  end

  def part1(input) do
    blocks = input |> One.split()

    One.compact([], blocks, Enum.reverse(blocks))
    |> One.checksum()
  end

  defmodule Two do
    def split(input) do
      Stream.resource(
        fn -> {:file, 0, String.split(input, "", trim: true)} end,
        fn
          {_, _, ["\n"]} -> {:halt, nil}
          {:file, id, [n | rest]} -> {file_block(id, n), {:space, id + 1, rest}}
          {:space, id, [n | rest]} -> {space_block(n), {:file, id, rest}}
        end,
        fn _ -> :ok end
      )
      |> Enum.to_list()
    end

    defp file_block(id, n) do
      [{:file, id, String.to_integer(n)}]
    end

    defp space_block(n) do
      [{:space, String.to_integer(n)}]
    end

    def checksum(blocks) do
      blocks
      |> Stream.with_index()
      |> Stream.map(fn
        {:space, _i} -> 0
        {n, i} -> n * i
      end)
      |> Enum.sum()
    end

    def to_blocks(blocks) do
      blocks
      |> Stream.flat_map(fn
        {:file, id, fl} -> Stream.duplicate(id, fl) |> Enum.to_list()
        {:space, sl} -> Stream.duplicate(:space, sl)
      end)
    end

    def compact(blocks, reverse) do
      Enum.reduce(reverse, blocks, fn
        {:space, _sl}, acc ->
          acc

        file, acc ->
          acc
          |> Enum.reduce({[], file}, fn
            # reached the same file block when done, add space for it
            ^file = {:file, _id, fl}, {acc, :done} ->
              {[{:space, fl} | acc], :done}

            # reached the same file block, so could not replace it, mark as done
            f, {acc, f} ->
              {[f | acc], :done}

            # reached another file block, continue reducing
            {:file, _, _} = f, {acc, file} ->
              {[f | acc], file}

            # reached a space block when done, add it and continue reducing
            {:space, n}, {acc, :done} ->
              {[{:space, n} | acc], :done}

            # reached a space block with exact same size, add it and mark done
            {:space, sl}, {acc, {:file, id, sl}} ->
              {[{:file, id, sl} | acc], :done}

            # reached a space that is not large enough, add it and continue
            {:space, sl}, {acc, {:file, id, fl}} when sl < fl ->
              {[{:space, sl} | acc], {:file, id, fl}}

            # reached a space that is larger than necessary, add file and remaining space, mark as done
            {:space, sl}, {acc, {:file, id, fl}} when sl > fl ->
              {[{:space, sl - fl}, {:file, id, fl} | acc], :done}
          end)
          |> then(&elem(&1, 0))
          |> Enum.reverse()
      end)
    end
  end

  def part2(input) do
    blocks = input |> Two.split()

    Two.compact(blocks, Enum.reverse(blocks))
    |> Two.to_blocks()
    |> Two.checksum()
  end
end
