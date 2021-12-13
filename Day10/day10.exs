defmodule Helpers do
  def get_input(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def categorize_nav_subsystems(nav_subsystem) do
    Enum.reduce_while(nav_subsystem, {nil, []}, fn char, {_, stack} -> is_valid_syntax(char, stack) end)
  end

  def is_valid_syntax(char, stack = []), do: {:cont, {:incomp, [char | stack]}}
  def is_valid_syntax(char, stack = [popped | rest]) do
    cond do
      is_open_char(char)              -> {:cont, {:incomp, [char | stack]}}
      char == get_close_char(popped)  -> {:cont, {:incomp, rest}}
      char != get_close_char(popped)  -> {:halt, {:corrupt, char}}
    end
  end

  def is_open_char(char), do: Enum.member?(to_charlist(["{", "[", "(", "<"]), char)
  def get_close_char(char), do: Map.get(%{"{" => "}", "[" => "]", "(" => ")", "<" => ">"}, char)
end

defmodule Part1 do
  import Helpers

  def get_char_score(char), do: Map.get(%{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}, char)

  def solve(file_path) do
    Enum.map(get_input(file_path), &categorize_nav_subsystems/1)
    |> Enum.filter(&match?({:corrupt, _}, &1))
    |> Enum.map(fn {_, char} -> get_char_score(char) end)
    |> Enum.sum
  end
end

defmodule Part2 do
  import Helpers

  def get_char_score(char), do: Map.get(%{")" => 1, "]" => 2, "}" => 3, ">" => 4}, char)

  def calc_scores(incomplete) do
    Enum.map(incomplete, &get_char_score(get_close_char(&1)))
    |> Enum.reduce(0, fn char_score, total -> (total * 5) + char_score end)
  end

  def solve(file_path) do
    autocomplete_scores = Enum.map(get_input(file_path), &categorize_nav_subsystems/1)
    |> Enum.filter(&match?({:incomp, _}, &1))
    |> Enum.map(fn {_, incomplete} -> calc_scores(incomplete) end)
    |> Enum.sort

    Enum.at(autocomplete_scores, div(length(autocomplete_scores), 2))
  end
end
