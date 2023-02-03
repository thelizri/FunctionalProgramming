defmodule Day8 do

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day8.txt")
		content = String.split(input, "\r\n")
		for row <- content do
			Enum.map(String.split(row, "", trim: true), fn(x) -> String.to_integer(x) end)
		end |> execute_program
	end

	def execute_program(matrix) do
		size = length(matrix)
		List.flatten(matrix) |> List.to_tuple()
	end

end