Code.compile_file("day13.exs")
Code.require_file("day13.exs")

test_match = %{
  {0, 6} => "#",
  {8, 4} => "#",
  {8, 10} => "#",
  {4, 3} => "#",
  {9, 0} => "#"
}

test_no_match = %{
  {8, 4} => "#"
}

# IO.puts("True: #{Part1.has_mirror_match?(test_match, ["y", 7], {8, 4})}")
# IO.puts("False: #{Part1.has_mirror_match?(test_no_match, ["y", 7], {8, 4})}")

# Part1.count_dots_after(test_match, ["y", 7]) |> IO.inspect
# Part1.count_dots_after(test_no_match, ["y", 7]) |> IO.inspect

{x, y} = Helpers.get_input("test")
new_board = MapSet.new(y, fn [x, y] -> {x, y} end)
|> Part1.run_instr(Enum.at(x, 0))
|> Part1.run_instr(Enum.at(x, 1))

Helpers.display_paper(new_board, 10, 6)

# 956 is too high
