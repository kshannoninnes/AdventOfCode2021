defmodule Helpers do
  def get_input(file_path) do
    file_path
    |> File.read!
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " | "))
  end

  def is_control_digit?(digit), do: Enum.member?([2, 3, 4, 7], String.length(digit))
end

defmodule Part1 do
  import Helpers

  def solve(file_path) do
    file_path
    |> get_input
    |> Enum.map(&List.last/1)
    |> Enum.map(&String.split/1)
    |> Enum.reduce(0, fn x, acc -> Enum.count(x, &is_control_digit?/1) + acc end)
  end
end

defmodule Part2 do
  import Helpers

  defp num_common_segments(first, second) do
    String.graphemes(first)
    |> Enum.uniq
    |> Enum.count(&Enum.member?(String.graphemes(second), &1))
  end

  defp get_digit_mask(digit, control_digits), do: Enum.map(control_digits, &num_common_segments(&1, digit))

  defp convert_from_mask(mask) do
    case mask do
      [_, _, _, 2] -> 1; [_, _, _, 4] -> 4; [_, _, _, 3] -> 7; [_, _, _, 7] -> 8
      [2, 3, 3, 6] -> 0; [1, 2, 3, 6] -> 6; [2, 3, 4, 6] -> 9;
      [1, 2, 2, 5] -> 2; [2, 3, 3, 5] -> 3; [1, 2, 3, 5] -> 5
    end
  end

  defp decode_output([pattern, output]) do
    output_digits = output |> String.split

    control_digits = pattern
    |> String.split
    |> Enum.filter(&is_control_digit?/1)
    |> Enum.sort_by(&String.length/1)

    Enum.map(output_digits, &get_digit_mask(&1, control_digits))
    |> Enum.map(&convert_from_mask/1)
    |> Integer.undigits
  end

  def solve(file_path) do
    file_path
    |> get_input
    |> Enum.reduce(0, fn x, acc -> decode_output(x) + acc end)
  end
end
