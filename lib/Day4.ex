defmodule Day4 do

	def read() do
		{:ok, input} = File.read("lib/Day4.txt")
		content = String.split(input, "\r\n")
		for_list(content, 0)
	end

	def for_list([head], score) do
		valueForRow = overlap(head)
		score+valueForRow
	end

	def for_list([head|rest], score) do
		valueForRow = overlap(head)
		for_list(rest, score+valueForRow)
	end

	def evaluate_row(row) do
		[first, last] = String.split(row, ",")
		first = eval_range(first)
		last = eval_range(last)
		
		cond do 
			MapSet.subset?(first, last) -> 1
			MapSet.subset?(last, first) -> 1
			true -> 0
		end
	end

	def eval_range(seq) do
		[first, last] = String.split(seq, "-")
		first = String.to_integer(first)
		last = String.to_integer(last)
		list = Enum.to_list(first..last)
		MapSet.new(list)
	end

	#part 2, check if they have an intersection
	def overlap(row) do
		[first, last] = String.split(row, ",")
		first = eval_range(first)
		last = eval_range(last)
		if MapSet.disjoint?(first, last) do
			0
		else
			1
		end
	end

end