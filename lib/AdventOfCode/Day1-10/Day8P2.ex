defmodule Day8Part2 do

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day8.txt")
		content = String.split(input, "\r\n")
		for row <- content do
			Enum.map(String.split(row, "", trim: true), fn(x) -> String.to_integer(x) end)
		end |> execute_program
	end

	def execute_program(matrix) do
		size = length(matrix)
		tuple = List.flatten(matrix) |> List.to_tuple()
		#traverse_matrix_spiral_order(0, size, size, tuple)
		getMaxScore(tuple)
	end

	##########################################################################
	# Part 2
	def get_scenic_score(index, size, tuple) do
		column = rem(index, size)
		row = floor(index/size)
		height = elem(tuple, index)
		up = walk_direction(height, index, size, tuple, row, :up, 0)
		right = walk_direction(height, index, size, tuple, size-column-1, :right, 0)
		down = walk_direction(height, index, size, tuple, size-row-1, :down, 0)
		left = walk_direction(height, index, size, tuple, column, :left, 0)
		score = left*right*up*down
	end

	def walk_direction(height, index, size, tuple, steps, direction, stepstaken) when steps < 1 do
		stepstaken
	end

	def walk_direction(height, index, size, tuple, steps, :up, stepstaken) do
		index = index - size
		cond do
			elem(tuple, index) >= height -> stepstaken+1
			true -> walk_direction(height, index, size, tuple, steps-1, :up, stepstaken+1)
		end
	end

	def walk_direction(height, index, size, tuple, steps, :right, stepstaken) do
		index = index + 1
		cond do
			elem(tuple, index) >= height -> stepstaken+1
			true -> walk_direction(height, index, size, tuple, steps-1, :right, stepstaken+1)
		end
	end

	def walk_direction(height, index, size, tuple, steps, :down, stepstaken) do
		index = index + size
		cond do
			elem(tuple, index) >= height -> stepstaken+1
			true -> walk_direction(height, index, size, tuple, steps-1, :down, stepstaken+1)
		end
	end

	def walk_direction(height, index, size, tuple, steps, :left, stepstaken) do
		index = index - 1
		cond do
			elem(tuple, index) >= height -> stepstaken+1
			true -> walk_direction(height, index, size, tuple, steps-1, :left, stepstaken+1)
		end
	end

	#############################################################################################
	# test

	def getMaxScore(tuple) do
		length = tuple_size(tuple)-1
		size = round(:math.sqrt(tuple_size(tuple)))
		for n <- 0..length do
			get_scenic_score(n, size, tuple)
		end
		|> Enum.reduce(fn(x, acc)->max(x,acc) end)
	end


end