defmodule Day3Part1 do

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day3.txt")
		content = String.split(input, "\r\n")
		loop_rows(content, 0)
	end

	def loop_rows([], score) do score end
	def loop_rows([head|rest], score) do
		{first, second} = String.split_at(head, div(String.length(head),2))
		set1 = String.to_charlist(first) |> MapSet.new()
		set2 = String.to_charlist(second) |> MapSet.new()
		intersection = MapSet.intersection(set1, set2)
		[letter] = MapSet.to_list(intersection)
		value = get_priority_of_character(letter)
		loop_rows(rest, score + value)
	end

	def get_priority_of_character(letter) do
		cond do
			97 <= letter and letter <= 122 -> # is a-z
				letter - 96
			65 <= letter and letter <= 90 -> # is A-Z
				letter - 38
		end
	end
end