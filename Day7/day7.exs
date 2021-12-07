defmodule Helpers do
  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def num_moves_to_target(target, list, step_func) do
    Enum.reduce(list, 0, fn x, acc -> step_func.(x, target) + acc end)
  end

  def solve(file_path, step_func) do
    input = file_path |> get_input
    {min, max} = Enum.min_max(input)

    min..max
    |> Enum.map(fn x -> num_moves_to_target(x, input, step_func) end)
    |> Enum.min
  end
end


# Had a solution that used the median for part 1, but couldn't work out part 2
# Used brute force for both in the end just to keep things tidy
defmodule Part1 do
  import Helpers

  def step_one(x, target), do: abs(x - target)
  def solve(file_path), do: Helpers.solve(file_path, &step_one/2)
end

defmodule Part2 do
  import Helpers

  def step_exp(x, target), do: 0..abs(x - target - 1) |> Enum.sum
  def solve(file_path), do: Helpers.solve(file_path, &step_exp/2)
end
