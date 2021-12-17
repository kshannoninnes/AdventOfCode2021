defmodule Helpers do
  def get_input(file_path) do
    input = file_path
    |> File.read!
    |> String.split("\n", trim: true)

    {Enum.filter(input, &String.starts_with?(&1, "fold"))
    |> Enum.map(&(String.split(&1, " ") |> List.last |> String.split("=")))
    |> Enum.map(fn [x, y] -> [x, String.to_integer(y)] end),

    Enum.reject(input, &String.starts_with?(&1, "fold"))
    |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&(String.to_integer(&1))) end)
    |> MapSet.new(fn [x, y] -> {x, y} end)}
  end

  def run_instr(["y", row], board), do: MapSet.new(board, &get_new_y(&1, row))
  def run_instr(["x", col], board), do: MapSet.new(board, &get_new_x(&1, col))

  def display_board(board) do
    max_x = Enum.max_by(board, &elem(&1, 0)) |> elem(0)
    max_y = Enum.max_by(board, &elem(&1, 1)) |> elem(1)

    IO.write(
      for y <- 0..max_y, x <- 0..max_x do
        char = if(MapSet.member?(board, {x, y}), do: "#", else: " ")
        if(div(x, max_x) == 1, do: "#{char}\n", else: char)
      end)
  end

  defp get_new_x({x, y}, col), do: if(x > col, do: {col - (x - col), y}, else: {x, y})
  defp get_new_y({x, y}, row), do: if(y > row, do: {x, row - (y - row)}, else: {x, y})
end

defmodule Part1 do
  import Helpers

  def solve(file_path) do
    {[first_instr | _], board} = file_path |> get_input

    first_instr
    |> run_instr(board)
    |> MapSet.size
  end
end

defmodule Part2 do
  import Helpers

  def solve(file_path) do
    {all_instr, board} = file_path |> get_input

    all_instr
    |> Enum.reduce(board, &run_instr(&1, &2))
    |> display_board
  end
end
