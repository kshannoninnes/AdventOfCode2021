defmodule Helper do
  def get_input(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> Enum.map(fn x -> String.split(x, " ") end)
    |> Enum.map(fn [x, y] -> [x, String.to_integer(y)] end)
  end
end

defmodule Part1 do
  def move([["forward", num] | tail], x, y) do move(tail, x + num, y) end
  def move([["up", num] | tail], x, y) do move(tail, x, y - num) end
  def move([["down", num] | tail], x, y) do move(tail, x, y + num) end
  def move([], x, y) do x * y end

  def solve(file_path) do
    content = Helper.get_input(file_path)
    move(content, 0, 0)
  end
end

defmodule Part2 do
  def move([["forward", num] | tail], x, y, aim) do move(tail, x + num, y + (num * aim), aim) end
  def move([["up", num] | tail], x, y, aim) do move(tail, x, y, aim - num) end
  def move([["down", num] | tail], x, y,aim ) do move(tail, x, y, aim + num) end
  def move([], x, y, _) do x * y end

  def solve(file_path) do
    content = Helper.get_input(file_path)
    move(content, 0, 0, 0)
  end
end
