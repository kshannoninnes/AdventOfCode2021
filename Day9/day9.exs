defmodule Helpers do
  def get_input(file_path) do
    input = File.read!(file_path)
    map = to_map(input)
    len = get_row_len(input)
    low_points = :maps.filter(fn k, v -> is_low_point?({k, v}, map, len) end, map)
    {map, low_points, len}
  end

  defp to_map(input) do
    String.replace(input, "\n", "")
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Map.new(fn {k, v} -> {v, k} end)
    |> (&(:maps.map(fn k, v -> if v == 9 do nil else v end end, &1))).()
  end

  defp get_row_len(input) do
    String.split(input)
    |> Enum.at(0)
    |> String.length
  end

  defp is_low_point?({key, num}, map, len) do
    get_neighbours(key, map, len)
    |> Enum.map(fn x -> Map.get(map, x) end)
    |> Enum.reduce(true, fn x, acc -> num < x && acc end)
  end

  def get_neighbours(key, map, len) do
    neighbours = [
      left = if Map.get(map, key - 1) && rem(key, len) != 0 do key - 1 end,
      right = if Map.get(map, key + 1) && rem(key + 1, len) != 0 do key + 1 end,
      above = if Map.get(map, key - len) do key - len end,
      below = if Map.get(map, key + len) do key + len end
    ]
  end
end

defmodule Part1 do
  import Helpers

  def solve(file_path) do
    {index_map, low_points, _} = get_input(file_path)

    Enum.reduce(low_points, 0, fn {_, num}, acc -> acc + num + 1 end)
  end
end

defmodule Part2 do
  import Helpers

  def sum_neighbours(key, map, len, visited) do
    visited = Map.put(visited, key, true)
    neighbours = get_neighbours(key, map, len) |> Enum.filter(fn x -> x != nil end)

    Enum.reduce(neighbours, {1, visited}, fn neighbour, {total, visited} -> # Sum all non-nil neighbours that have not been visited
      {sum, visited} = if not Map.get(visited, neighbour, false) do sum_neighbours(neighbour, map, len, visited) else {0, visited} end
      {total + sum, visited}
    end)
  end

  def solve_clean(file_path) do
    {index_map, low_points, wrap_len} = get_input(file_path)

    Enum.map(low_points, fn {k, _} -> sum_neighbours(k, index_map, wrap_len, Map.new) end)
    |> Enum.map(fn {sum, _} -> sum end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end
end
