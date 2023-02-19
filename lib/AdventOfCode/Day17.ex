# seven units wide
# Three units above the highest rock
# Two units away from the left wall

defmodule Day17 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day17.txt")
		list = String.to_charlist(content) |> List.to_tuple
		{-1, list}

	end

	def print(list) do
		Enum.each(list, fn(x)-> case x do
				62 -> IO.puts("Right")
				60 -> IO.puts("Left")
			end end)
	end

	def getNext({index, list}) do
		size=tuple_size(list)
		index = rem(index+1, size)
		{elem(list, index), {index, list}}
	end

	def getRock(round, max_y) do
		round = rem(round, 5)
		y = max_y+4
	end

	def getRock(:line, y) do
		[{2, y},{3, y},{4, y},{5, y}]
	end

	def getRock(:plus, y) do
		[{2, y+1},{3, y},{3, y+1},{3, y+2},{4, y+1}]
	end

	def getRock(:thel, y) do
		[{2, y},{3, y},{4, y},{4, y+1}, {4, y+2}]
	end

	def getRock(:wall, y) do
		[{2, y},{2, y+1},{2, y+2},{2, y+3}]
	end

	def getRock(:square, y) do
		[{2, y},{3, y},{2, y+1},{3, y+1}]
	end

	def getTopMost(list) do
		Enum.reduce(list, -1, fn({x,y}, acc)-> max(y, acc) end)
	end

	def getLeftMost(list) do
		Enum.reduce(list, 100, fn({x,y}, acc)-> min(x, acc) end)
	end

	def getRightMost(list) do
		Enum.reduce(list, -100, fn({x,y}, acc)-> max(x, acc) end)
	end

	def getBottomMost(list) do
		Enum.reduce(list, nil, fn({x,y}, acc)-> case acc do
			nil -> y; _ -> min(acc, y) end end)
	end

end