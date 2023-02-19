# seven units wide
# Three units above the highest rock
# Two units away from the left wall

defmodule Day17 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day17.txt")
		list = String.to_charlist(content) |> List.to_tuple
		blizzards = {-1, list}
		mapset = MapSet.new([{0,0},{1,0},{2,0},{3,0},{4,0},{5,0},{6,0}])
		run_cycle(0, mapset, blizzards)
	end

	def run_cycle(num, mapset, blizzards) when num < 10 do
		max_y = getTopMost(MapSet.to_list(mapset))
		rock = getRock(num, max_y)
		mapset = move(rock, mapset, blizzards)
		run_cycle(num+1, mapset, blizzards)
	end

	def run_cycle(_num, mapset, _blizzards) do
		IO.inspect(mapset)
		max_y = getTopMost(MapSet.to_list(mapset))
	end

	def getNext({index, list}) do
		size=tuple_size(list)
		index = rem(index+1, size)
		{elem(list, index), {index, list}}
	end

	def getRock(round, max_y) when is_integer(round) do
		round = rem(round, 5)
		y = max_y+4
		case round do
			0 -> getRock(:row, y)
			1 -> getRock(:plus, y)
			2 -> getRock(:thel, y)
			3 -> getRock(:column, y)
			4 -> getRock(:square, y)
		end
	end

	def getRock(:row, y) do
		[{2, y},{3, y},{4, y},{5, y}]
	end

	def getRock(:plus, y) do
		[{2, y+1},{3, y},{3, y+1},{3, y+2},{4, y+1}]
	end

	def getRock(:thel, y) do
		[{2, y},{3, y},{4, y},{4, y+1}, {4, y+2}]
	end

	def getRock(:column, y) do
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

	def move(rock, mapset, blizzards) do
		{direction, blizzards} = getNext(blizzards)
		rock = case direction do
			62 -> move_right(rock)
			60 -> move_left(rock)
		end
		case move_down(rock, mapset) do
			true -> rock = Enum.map(rock, fn({x,y})->{x, y-1} end); move(rock, mapset, blizzards)
			false -> Enum.reduce(rock, mapset, fn(pos, acc)-> MapSet.put(acc, pos) end)
		end
	end

	def move_right(rock) do
		r = getRightMost(rock)
		cond do
			r < 6 -> Enum.map(rock, fn({x,y})->{x+1, y} end)
			true -> rock
		end
	end

	def move_left(rock) do
		l = getLeftMost(rock)
		cond do
			l > 0 -> Enum.map(rock, fn({x,y})->{x-1, y} end)
			true -> rock
		end
	end

	def move_down([], mapset) do true end
	def move_down([pos|rest], mapset) do
		cond do
			MapSet.member?(mapset, pos) -> false
			true -> move_down(rest, mapset)
		end
	end


end