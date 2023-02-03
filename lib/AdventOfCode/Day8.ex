defmodule Day8 do

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day8.txt")
		content = String.split(input, "\r\n")
		for row <- content do
			Enum.map(String.split(row, " ", trim: true), fn(x) -> String.to_integer(x) end)
		end |> execute_program
	end

	def execute_program(matrix) do
		size = length(matrix)
		tuple = List.flatten(matrix) |> List.to_tuple()
		traverse_matrix_spiral_order(size, 0, 0, size, tuple)
	end

	def traverse_matrix_spiral_order(size, index, acc, width, tuple) when width > 1 do
		{acc, index} = move(acc, index, width-1, size, tuple, :right)
		{acc, index} = move(acc, index+size, width-2, size, tuple, :down)
		{acc, index} = move(acc, index-1, width-2, size, tuple, :left)
		{acc, index} = move(acc, index-size, width-3, size, tuple, :up)
		traverse_matrix_spiral_order(size, index+1, acc, width-2, tuple)
	end

	def traverse_matrix_spiral_order(size, index, acc, 1, tuple) do
		eval_position(index, tuple)
		IO.write("Done")
	end

	def traverse_matrix_spiral_order(size, index, acc, width, tuple) do
		IO.write("Done")
	end

	#Move
	def move(acc, index, 0, size, tuple, direction) do
		eval_position(index, tuple)
		{acc, index}
	end

	def move(acc, index, steps, size, tuple, direction) do
		eval_position(index, tuple)
		case direction do
			:up -> move(acc, index-size, steps-1, size, tuple, :up)
			:right -> move(acc, index+1, steps-1, size, tuple, :right)
			:down -> move(acc, index+size, steps-1, size, tuple, :down)
			:left -> move(acc, index-1, steps-1, size, tuple, :left)
		end
	end

	def eval_position(index, tuple) do
		IO.write("Index:#{index}    ")
		value = elem(tuple, index)
		IO.write("Value: #{value}\n")
	end

end