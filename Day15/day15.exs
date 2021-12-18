defmodule Helpers do
  Mix.install([{:libgraph, github: "bitwalker/libgraph", branch: "main"}])

  def solve(file_path, [scalar: scalar]) do
    {vector_len, map} = file_path |> get_input

    map
    |> get_scaled_vertices(scalar, vector_len)
    |> build_graph
    |> sum_shortest_path(vector_len * scalar - 1)
  end

  # Input Operations
  defp get_input(file_path) do
    list = file_path
    |> File.read!
    |> String.split
    |> Enum.map(&String.graphemes/1)

    vector_len = list |> length
    map = list
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
    |> to_indexed_vector
    |> to_indexed_matrix(vector_len)

    {vector_len, map}
  end

  defp to_indexed_vector(list), do: Enum.with_index(list, fn k, v -> {v, k} end)
  defp to_indexed_matrix(map, len), do: Map.new(map, fn {k, v} -> {{div(k, len), rem(k, len)}, v} end)

  # Scaling Operations
  defp get_scaled_vertices(map, scale, grid_offset) do
    Enum.reduce(0..scale - 1, map, fn row_iter, row_map ->
      Map.merge(row_map,
        Enum.reduce(0..scale - 1, row_map, fn col_iter, col_map ->
          row_offset = row_iter * grid_offset
          col_offset = col_iter * grid_offset
          val_scalar = row_iter + col_iter

          Map.merge(col_map, get_scaled_map(map, row_offset, col_offset, val_scalar))
        end))
    end)
  end

  defp get_scaled_map(map, row_offset, col_offset, _) when row_offset == 0 and col_offset == 0, do: map
  defp get_scaled_map(map, row_offset, col_offset, incr_val) do
    Map.new(map, fn {{row, col}, val} ->
      new_row = row + row_offset
      new_col = col + col_offset
      new_val = rem((val - 1) + incr_val, 9) + 1

      {{new_row, new_col}, new_val}
    end)
  end

  # Graph Operations
  def build_graph(vertices) do
    for v <- vertices, reduce: Graph.new(vertex_identifier: &(&1))
    do g -> Graph.add_edges(g, get_edges(v, vertices)) end
  end

  defp get_edges({{y, x}, _val}, map) do
    [
      {{y, x}, {y + 1, x}, weight: Map.get(map, {y + 1, x})},
      {{y, x}, {y - 1, x}, weight: Map.get(map, {y - 1, x})},
      {{y, x}, {y, x + 1}, weight: Map.get(map, {y, x + 1})},
      {{y, x}, {y, x - 1}, weight: Map.get(map, {y, x - 1})}
    ] |> Enum.filter(fn {_, _, [weight: w]} -> w != nil end)
  end

  def sum_shortest_path(graph, max_idx) do
    sp = Graph.dijkstra(graph, {0, 0}, {max_idx, max_idx})
    for [v1, v2] <- Enum.chunk_every(sp, 2, 1, :discard), reduce: 0
    do total -> total + Graph.edge(graph, v1, v2).weight end
  end
end

defmodule Part1, do: def solve(file_path), do: Helpers.solve(file_path, scalar: 1)
defmodule Part2, do: def solve(file_path), do: Helpers.solve(file_path, scalar: 5)
