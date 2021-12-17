defmodule Helpers do
  def get_input(file_path) do
    [template | rules] = file_path
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> "))

    template_freqs = template
    |> List.first
    |> String.graphemes
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.frequencies

    {List.first(template), template_freqs, Map.new(rules, fn [x, y] -> {x, y} end)}
  end

  def calc_freqs(template, freqs, rules, steps) when steps == 0, do: get_char_freqs(freqs, %{String.last(template) => 1})
  def calc_freqs(template, freqs, rules, steps), do: calc_freqs(template, get_pair_freqs(freqs, rules), rules, steps - 1)

  def sub_min_from_max(freqs) do
    freqs
    |> Enum.min_max_by(fn {_, freq} -> freq end)
    |> then(fn {{_, min}, {_, max}} -> max - min end)
  end

  defp get_char_freqs(pair_freqs, initial_freqs) do
    Enum.reduce(pair_freqs, initial_freqs, fn {pair, freq}, char_freqs ->
      Map.update(char_freqs, String.first(pair), freq, &(freq + &1))
    end)
  end

  defp get_pair_freqs(freqs, rules) do
    Enum.reduce(freqs, Map.new, fn {pair, count}, new_freqs ->
      [first, last] = String.graphemes(pair)
      Map.update(new_freqs, first <> Map.get(rules, pair), count, &(count + &1))
      |> Map.update(Map.get(rules, pair) <> last, count, &(count + &1))
    end)
  end
end

defmodule Part1 do
  import Helpers

  def solve(file_path) do
    {template, template_freqs, rules} = get_input(file_path)
    calc_freqs(template, template_freqs, rules, 10)
    |> sub_min_from_max
  end
end

defmodule Part2 do
  import Helpers

  def solve(file_path) do
    {template, template_freqs, rules} = get_input(file_path)
    calc_freqs(template, template_freqs, rules, 40)
    |> sub_min_from_max
  end
end
