defmodule Helpers do
  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end


defmodule Part1 do
  @moduledoc """
    Using the median as the convergence point. If the input size is of even length,
    either of the two median numbers will work
  """
  import Helpers

  def step_one(x, target), do: abs(x - target)

  def solve(file_path) do
    input = file_path |> get_input |> Enum.sort
    median = Enum.at(input, (length(input) / 2) |> ceil)

    Enum.reduce(input, 0, fn x, acc -> step_one(x, median) + acc end)
  end
end


defmodule Part2 do
  @moduledoc """
    Using upper and lower bound means and taking the minimum solution. No idea if
    there's a closed-form solution for part 2. If there is, it's way more complicated
    than it should be for day 7.
  """
  import Helpers

  def step_exp(x, target), do: 0..abs(x - target) |> Enum.sum

  def solve(file_path) do
    input = file_path |> get_input
    mean = Enum.sum(input) / length(input)

    min(
    Enum.reduce(input, 0, fn x, acc -> step_exp(x, mean |> ceil) + acc end),
    Enum.reduce(input, 0, fn x, acc -> step_exp(x, mean |> floor) + acc end))
  end
end
