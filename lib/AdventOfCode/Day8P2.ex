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
		traverse_matrix_spiral_order(0, size, size, tuple)
	end

	def traverse_matrix_spiral_order(index, size, width, tuple) when width > 1 do
		index = move(index, width-1, size, tuple, :right)
		index = move(index+size, width-2, size, tuple, :down)
		index = move(index-1, width-2, size, tuple, :left)
		index = move(index-size, width-3, size, tuple, :up)
		traverse_matrix_spiral_order(index+1, size, width-2, tuple)
	end

	def traverse_matrix_spiral_order(index, _, 1, _) do
		move(index, 0, nil, nil, nil)
		IO.puts("Done")
	end

	def traverse_matrix_spiral_order(_, _, _, _) do
		IO.puts("Done")
	end

	#Move
	def move(index, 0, _, _, _) do
		IO.puts("Current index: #{index}")
		index
	end

	def move(index, steps, size, tuple, direction) do
		IO.puts("Current index: #{index}")
		case direction do
			:up -> move(index-size, steps-1, size, tuple, :up)
			:right -> move(index+1, steps-1, size, tuple, :right)
			:down -> move(index+size, steps-1, size, tuple, :down)
			:left -> move(index-1, steps-1, size, tuple, :left)
		end
	end

	##########################################################################
	# Part 2
	def get_scenic_score(index, size, tuple, {maxindex, maxscore}) do
		column = rem(index, size)
		row = floor(index/size)
		IO.puts("Is this index gonna cause an error: #{index}")
		height = elem(tuple, index)
		up = walk_direction(height, index, size, tuple, row, :up, 1)
		right = walk_direction(height, index, size, tuple, size-column-1, :right, 1)
		down = walk_direction(height, index, size, tuple, size-row-1, :down, 1)
		left = walk_direction(height, index, size, tuple, column, :left, 1)
		score = left*right*up*down
		IO.puts("Score is: #{score} for index: #{index}")
		cond do
			score > maxscore -> {index, score}
			true -> {maxindex, maxscore}
		end
	end

	def walk_direction(height, index, size, tuple, steps, direction, stepstaken) when steps < 1 do
		stepstaken
	end

	def walk_direction(height, index, size, tuple, steps, :up, stepstaken) do
		index = index - size
		cond do
			elem(tuple, index) >= height -> stepstaken
			true -> walk_direction(height, index, size, tuple, steps-1, :up, stepstaken+1)
		end
	end

	def walk_direction(height, index, size, tuple, steps, :right, stepstaken) do
		index = index + 1
		cond do
			elem(tuple, index) >= height -> stepstaken
			true -> walk_direction(height, index, size, tuple, steps-1, :right, stepstaken+1)
		end
	end

	def walk_direction(height, index, size, tuple, steps, :down, stepstaken) do
		index = index + size
		cond do
			elem(tuple, index) >= height -> stepstaken
			true -> walk_direction(height, index, size, tuple, steps-1, :down, stepstaken+1)
		end
	end

	def walk_direction(height, index, size, tuple, steps, :left, stepstaken) do
		index = index - 1
		cond do
			elem(tuple, index) >= height -> stepstaken
			true -> walk_direction(height, index, size, tuple, steps-1, :left, stepstaken+1)
		end
	end

end