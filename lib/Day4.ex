defmodule Day4 do

	def read() do
		{:ok, input} = File.read("lib/Day4.txt")
		content = String.split(input, "\r\n")
		for row <- content do
			row
		end
	end

	def evaluate_row(row) do
		[first, last] = String.split(row, ",")
		first = eval_range(first)
		last = eval_range(last)
		{first, last}
	end

	def eval_range(seq) do
		[first, last] = String.split(seq, "-")
		first = String.to_integer(first)
		last = String.to_integer(last)
		Enum.to_list(first..last)
	end

end