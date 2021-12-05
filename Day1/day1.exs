defmodule Helper do
  def get_integers(file_path) do
    File.read!(file_path)
    |> String.split(str)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Part1 do
  def solve(file_path) do
    Helper.get_integers(file_path)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> y > x end)
  end
end

defmodule Part2 do
  def solve(file_path) do
    Helper.get_integers(file_path)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> y > x end)
  end
end
