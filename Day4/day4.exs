defmodule Helpers do
  defp get_input(file_path), do: File.read!(file_path) |> String.split("\n", trim: true)
  defp get_number_pool(input), do: Enum.at(input, 0) |> String.split(",")
  defp get_game_boards(input), do: Enum.slice(input, 1..length(input)) |> Enum.map(&String.split(&1, " ", trim: true)) |> Enum.chunk_every(5)
  defp rotate(board), do: List.zip(board) |> Enum.map(&Tuple.to_list/1)
  defp remove_cell(board, cell), do: Enum.map(board, &Enum.reject(&1, fn x -> x == cell end))

  # Play out a bingo game, given a number pool, a board, and a number of moves
  defp play([last_draw | _], board, moves_left) when moves_left == 1, do: {last_draw, remove_cell(board, last_draw)}
  defp play([drawn | pool], board, moves_left) do
    new_board = remove_cell(board, drawn)
    play(pool, new_board, moves_left - 1)
  end

  # Get the minimum number of moves to reach bingo for a specified game board
  defp get_cell_bingo(cell, num_pool), do: Map.get(num_pool, cell)
  defp get_row_bingo(row, num_pool), do: Enum.map(row, &get_cell_bingo(&1, num_pool)) |> Enum.max
  defp get_board_bingo(board, num_pool) do
    h_min = Enum.map(board, &get_row_bingo(&1, num_pool)) |> Enum.min
    v_min = rotate(board) |> Enum.map(&get_row_bingo(&1, num_pool)) |> Enum.min
    Kernel.min(h_min, v_min)
  end

  # Chooser_func is used to decide between solving for the first or last winning board
  def solve(file_path, chooser_func) do
    input = get_input(file_path)
    num_pool = get_number_pool(input)
    boards = get_game_boards(input)

    {move_index, winning_board_index} = Enum.map(boards, &get_board_bingo(&1, num_pool |> Enum.with_index |> Map.new))
    |> Enum.with_index |> chooser_func.()

    winning_board = Enum.at(boards, winning_board_index)
    {last_draw, board} = play(num_pool, winning_board, move_index + 1)

    String.to_integer(last_draw) * (board |> List.flatten |> Enum.map(&String.to_integer/1) |> Enum.sum)
  end
end

defmodule Part1 do
  import Helpers
  def solve(file_path), do: solve(file_path, &Enum.min/1)
end

defmodule Part2 do
  import Helpers
  def solve(file_path), do: solve(file_path, &Enum.max/1)
end
