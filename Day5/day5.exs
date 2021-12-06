defmodule Helpers do
  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.map(&to_integers/1)
    |> Enum.map(&to_map/1)
  end

  defp to_integers(line), do: Enum.map(line, fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) end)
  defp to_map([[x1, y1], [x2, y2]]), do: %{x1: x1, y1: y1, x2: x2, y2: y2}

  def generate_all_points(line) when line.y1 == line.y2, do: for x <- line.x1..line.x2, do: {x, line.y1}
  def generate_all_points(line) when line.x1 == line.x2, do: for y <- line.y1..line.y2, do: {line.x1, y}
  def generate_all_points(line), do: Enum.zip(line.x1..line.x2, line.y1..line.y2)

  def update_points(point, all_points), do: Map.update(all_points, point, 1, fn x -> x + 1 end)

  def update_point_map(list, map) when length(list) == 0, do: map
  def update_point_map([current_list | rest], point_map), do: update_point_map(rest, Enum.reduce(current_list, point_map, &update_points/2))

  def overlapping_points(x), do: x > 1
end

defmodule Part1 do
  import Helpers

  def is_diagonal?(line), do: line.x1 != line.x2 and line.y1 != line.y2

  def solve(file_path) do
    file_path
    |> get_input
    |> Enum.reject(&is_diagonal?/1)
    |> Enum.map(&generate_all_points/1)
    |> update_point_map(Map.new)
    |> Map.values
    |> Enum.count(&overlapping_points/1)
  end
end

defmodule Part2 do
  import Helpers

  def solve(file_path) do
    file_path
    |> get_input
    |> Enum.map(&generate_all_points/1)
    |> update_point_map(Map.new)
    |> Map.values
    |> Enum.count(&overlapping_points/1)
  end
end
