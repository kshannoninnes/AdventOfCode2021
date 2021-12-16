defmodule Helpers do
  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.split
    |> Enum.map(&String.split(&1, "-"))
    |> build_adj_list
  end

  def get_paths(adj_list, node, visited, chosen \\ nil)
  def get_paths(_, node, _, _) when node == "end", do: [["end"]]
  def get_paths(adj_list, node, visited, chosen) do
    visited = Map.update(visited, node, 1, &(&1 + 1))
    new_paths = get_adjacent(adj_list, node, visited, chosen)
    Enum.reduce(new_paths, [], fn adj, paths ->
      new_paths = get_paths(adj_list, adj, visited, chosen)
      Enum.map(new_paths, &([adj] ++ &1)) ++ paths
    end)
  end

  defp add_one_way_edge(adj_list, a, b), do: Map.update(adj_list, a, MapSet.new([b]), &MapSet.put(&1, b))
  defp add_two_way_edge(adj_list, a, b), do: add_one_way_edge(adj_list, a, b) |> add_one_way_edge(b, a)
  defp build_adj_list(edge_list) do
    Enum.reduce(edge_list, Map.new(%{"end" => MapSet.new}), fn [a, b], adj_list ->
      cond do
        a == "end" or b == "start"  -> add_one_way_edge(adj_list, b, a)
        a == "start" or b == "end"  -> add_one_way_edge(adj_list, a, b)
        true                        -> add_two_way_edge(adj_list, a, b)
      end
    end)
  end

  defp get_adjacent(adj_list, node, visited, chosen) do
    Map.get(adj_list, node) |> Enum.filter(&valid_dest?(&1, visited, chosen))
  end

  defp valid_dest?(node, visited, chosen) when chosen == node, do: Map.get(visited, node, 0) < 2 or valid_dest?(node)
  defp valid_dest?(node, visited, chosen) when chosen != node, do: not(Map.has_key?(visited, node)) or valid_dest?(node)
  defp valid_dest?(node), do: node == String.upcase(node) or node == "end"
end

defmodule Part1 do
  import Helpers

  def solve(file_path), do: file_path |> get_input |> get_paths("start", Map.new, Map.new) |> Enum.count
end

defmodule Part2 do
  import Helpers

  def solve(file_path), do: file_path |> get_input |> get_paths_with_chosen

  def is_chosen?(str), do: String.upcase(str) != str and str != "start" and str != "end"
  def get_paths_with_chosen(adj_list) do
    chosen_ones = adj_list |> Map.keys |> Enum.filter(&is_chosen?/1)
    Enum.reduce(chosen_ones, [], fn chosen, all_paths -> get_paths(adj_list, "start", Map.new, chosen) ++ all_paths end)
    |> MapSet.new
    |> MapSet.size
  end
end
