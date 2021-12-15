defmodule Helpers do

  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.replace("\n", "")
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({Map.new, 0}, fn num, {map, idx} ->
      {Map.put_new(map, {div(idx, 10), rem(idx, 10)}, num), idx + 1}
    end)
    |> elem(0)
  end

  def simulate_steps(board, total_steps, total_flashes \\ 0) do
    total_steps = total_steps - 1 # Using negatives lets us infinite loop for part 2
    board = Map.new(board, fn {{row, col}, num} -> {{row, col}, num + 1} end)
    {board, high_energy} = process_energy_levels(board, Map.new)
    board = reset_high_nodes(board)
    new_flashes = map_size(high_energy)

    cond do
      total_steps == 0    -> total_flashes + new_flashes
      new_flashes == 100  -> abs(total_steps)
      true                -> simulate_steps(board, total_steps, total_flashes + new_flashes)
    end
  end

  def process_energy_levels(board, high_energy) do
    new_high_energy = get_high_energy(board, high_energy)
    board = incr_high_energy_neighbours(board, new_high_energy)
    new_high_energy = Map.new(new_high_energy, fn {xy, _} -> {xy, true} end)

    case new_high_energy != high_energy do # Have we gained new high energy nodes?
      false -> {board, new_high_energy}
      true  -> process_energy_levels(board, new_high_energy)
    end
  end

  defp reset_high_nodes(board) do
    Map.new(board, fn
      {xy, val} when val > 9  -> {xy, 0}
      node                    -> node
    end)
  end

  def get_high_energy(board, flash_map) do
    Enum.reduce(board, flash_map, fn
        {xy, val}, acc when val > 9 -> Map.put_new(acc, xy, false)
        _, acc                      -> acc
      end)
  end

  defp incr_high_energy_neighbours(board, map) do
    for {coords, false} <- map,
    reduce: board do new_board ->
      incr_neighbours(new_board, coords)
    end
  end

  defp incr_neighbours(board, {row, col}) do
    for x <- (col - 1)..(col + 1), y <- (row - 1)..(row + 1),
        (x != col or y != row),
        reduce: board
        do updated ->
          incr_node(updated, y, x)
        end
  end

  defguard in_range(min, val, max) when min <= val and val <= max
  def incr_node(board, row, _) when not in_range(0, row, 9), do: board
  def incr_node(board, _, col) when not in_range(0, col, 9), do: board
  def incr_node(board, row, col), do: Map.update!(board, {row, col}, fn x -> x + 1 end)
end

defmodule Part1 do
  import Helpers

  def solve(file_path, max_steps) do
    file_path |> get_input |> simulate_steps(max_steps)
  end
end

defmodule Part2 do
  import Helpers

  def solve(file_path) do
    file_path |> get_input |> simulate_steps(0)
  end
end
