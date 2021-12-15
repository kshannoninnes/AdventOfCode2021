# Starting to approach the point where it's too much work to minimize my code for an AOC problem...
defmodule Helpers do
  def simulate(file_path, steps_remaining, in_sync \\ false) do
    board = file_path |> get_input

    Enum.reduce_while(1..steps_remaining, {board, 0}, fn step, {updated, count} ->
        updated = incr_board(updated)
        {updated, flashes} = process_nodes(updated, Map.new)
        updated = reset_flashes(updated, flashes)

        if(in_sync && map_size(flashes) == 100) do
          {:halt, {updated, step}}
        else
          {:cont, {updated, count + map_size(flashes)}}
        end
    end) |> then(fn {_, total} -> total end)
  end

  defp get_input(file_path) do
    file_path
    |> File.read!
    |> String.split
    |> Enum.map(&to_integer_map/1)
    |> Enum.with_index
    |> Map.new(fn {k, v} -> {v, k} end)
  end

  defp incr_board(board) do
    Map.new(board, fn {row, submap} ->
      {row, Map.new(submap, fn {col, energy} ->
        {col, energy + 1}
      end)}
    end)
  end

  defp process_nodes(board, map) do
    updated_map = collect_flashing_nodes(board, map)
    updated_board = update_flashing_neighbours(board, updated_map)
    processed_map = Map.new(updated_map, fn {node, _} -> {node, true} end)

    if board == updated_board do
      {board, processed_map}
    else
      process_nodes(updated_board, processed_map)
    end
  end

  defp reset_flashes(board, flashes) do
    Enum.reduce(flashes, board, fn {{row, col}, _}, updated ->
      update_in(updated[row][col], fn _ -> 0 end)
    end)
  end

  defp to_integer_map(row) do
    row
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Map.new(fn {k, v} -> {v, k} end)
  end

  defp incr_neighbours(board, row, col) do
    for x <- (col - 1)..(col + 1), y <- (row - 1)..(row + 1),
        (x != col or y != row),
        reduce: board
        do updated ->
          incr_node(updated, y, x)
        end
  end

  defp incr_node(board, row, col) do
    if within_bounds?(row, col, map_size(board)) do
      update_in(board[row][col], fn x -> x + 1 end)
    else
      board
    end
  end

  defp within_bounds?(row, col, max), do: (row >= 0 and col >= 0) and (row < max and col < max)

  defp collect_flashing_nodes(board, flashing_nodes) do
    Enum.reduce(board, flashing_nodes, fn {y, row}, updated ->
      Enum.reduce(row, updated, fn {x, node}, acc ->
        if node == nil or node <= 9 do acc
        else Map.put_new(acc, {y, x}, false) end
      end)
    end)
  end

  defp update_flashing_neighbours(board, map) do
    Enum.reduce(map, board, fn {{row, col}, processed}, new_board ->
      case processed do
        false -> incr_neighbours(new_board, row, col)
        true -> new_board
      end
    end)
  end

end

defmodule Part1 do
  import Helpers

  def solve(file_path, num_steps) do
    simulate(file_path, num_steps)
  end
end

defmodule Part2 do
  import Helpers

  def solve(file_path, num_steps) do
    simulate(file_path, num_steps, true)
  end
end
