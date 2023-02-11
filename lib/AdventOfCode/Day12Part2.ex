defmodule Day12Part2 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day12.txt")
		initProgram(content)
	end

	def splitRows(content) do
		rows = String.split(content, "\r\n")
	end

	def getDimensions(rows) do
		num_rows = length(rows)
		[head|rest] = rows
		num_columns = String.split(head, "", trim: true) |> length
		{num_rows, num_columns}
	end

	def initProgram(content) do
		rows = splitRows(content)
		dim = getDimensions(rows)
		list = Enum.map(rows, fn(x)->String.to_charlist(x) end)
		|> List.flatten
		destination = Enum.find_index(list, fn(x)-> x == 69 end)
		list = Enum.map(list, fn(x)-> case x do 83 -> 97; 69 -> 122; _ -> x; end end)
	end

end