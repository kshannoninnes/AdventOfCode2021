defmodule Helpers do
  def get_input(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
  end

  def to_integer(num_list), do: Enum.join(num_list, "") |> String.to_integer(2)

  defp get_max(%{0 => x, 1 => y}) when x > y, do: 0
  defp get_max(%{0 => x, 1 => y}) when y >= x, do: 1

  def get_mcb(list), do: Enum.frequencies(list) |> get_max
end

defmodule Part1 do
  import Helpers

  defp rotate(list), do: List.zip(list) |> Enum.map(&Tuple.to_list/1)

  def solve(file_path) do
    mcbs = get_input(file_path) |> rotate |> Enum.map(&get_mcb/1)
    eps = Enum.map(mcbs, &Bitwise.bxor(&1, 1)) |> to_integer

    to_integer(mcbs) * eps
  end
end

defmodule Part2 do
  import Helpers

  defp get_mcb_from_cols(list, col), do: Enum.map(list, &Enum.at(&1, col)) |> get_mcb

  defp filter(list, _, _) when length(list) == 1, do: Enum.at(list, 0)
  defp filter(list, index, bit_criteria) do
    mcb = bit_criteria.(list, index)
    filtered = Enum.filter(list, fn x -> Enum.at(x, index) == mcb end)
    filter(filtered, index + 1, bit_criteria)
  end

  def solve(file_path) do
    input = get_input(file_path)
    oxy_rating = filter(input, 0, &get_mcb_from_cols/2)
    co2_rating = filter(input, 0, &get_mcb_from_cols(&1, &2) |> Bitwise.bxor(1))
    to_integer(oxy_rating) * to_integer(co2_rating)
  end
end
