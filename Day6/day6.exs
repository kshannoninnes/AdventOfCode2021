defmodule Helpers do
  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Part1 do
  import Helpers

  def update_fish(_, day, days_max, count) when day == days_max, do: count
  def update_fish(fish_map, day, days_max, count) do
    new_borns = Map.get(fish_map, day - 7, 0) + Map.get(fish_map, day - 9, 0)
    new_map = Map.update(fish_map, day, new_borns, fn x -> x + new_borns end)
    update_fish(new_map, day + 1, days_max, count + Map.get(new_map, day))
  end

  def solve(file_path, days) do
    initial_fish = file_path |> get_input

    Enum.frequencies(initial_fish)
    |> update_fish(1, days, length(initial_fish))
  end
end
