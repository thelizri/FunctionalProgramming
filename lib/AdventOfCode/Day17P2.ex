# seven units wide
# Three units above the highest rock
# Two units away from the left wall

defmodule Day17P2 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day17.txt")
		list = String.to_charlist(content) |> List.to_tuple
		blizzards = {-1, list}
		mapset = MapSet.new([{0,0},{1,0},{2,0},{3,0},{4,0},{5,0},{6,0}])
		run(0, mapset, blizzards)
	end

	def run(round, mapset, blizzards) when round < 2022 do
		max_y = getTopMost(MapSet.to_list(mapset))
		rock = getRock(round, max_y)
		{mapset, blizzards} = move(round, rock, mapset, blizzards)
		run(round+1, mapset, blizzards)
	end

	def run(_num, mapset, _blizzards) do
		max_y = getTopMost(MapSet.to_list(mapset))
	end

	def move(round, rock, mapset, blizzards) do
		{direction, blizzards} = getNext(blizzards)
		newRock = case direction do
			62 -> move_right(rock)
			60 -> move_left(rock)
		end
		rock = case isOccupied(newRock, mapset) do
			true -> rock
			false -> newRock
		end
		newRock = move_down(rock)
		case isOccupied(newRock, mapset) do
			true -> {Enum.reduce(rock, mapset, fn(pos, acc)-> MapSet.put(acc, pos) end), blizzards}
			false -> move(round, newRock, mapset, blizzards)
		end
	end

	def getNext({index, list}) do
		size=tuple_size(list)
		index = rem(index+1, size)
		{elem(list, index), {index, list}}
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

	def move_left(rock) do
		cond do
			0 < getLeftMost(rock) -> Enum.map(rock, fn({x,y})->{x-1, y} end)
			true -> rock
		end
	end

	def move_right(rock) do
		cond do
			getRightMost(rock) < 6 -> Enum.map(rock, fn({x,y})->{x+1, y} end)
			true -> rock
		end
	end

	def move_down(rock) do
		Enum.map(rock, fn({x,y})->{x, y-1} end)
	end

	def isOccupied([], mapset) do false end
	def isOccupied([pos|rest], mapset) do
		case MapSet.member?(mapset, pos) do
			true -> true
			false -> isOccupied(rest, mapset)
		end
	end

	def getRock(round, max_y) when is_integer(round) do
		round = rem(round, 5)
		y = max_y+4
		case round do
			0 -> [{2, y},{3, y},{4, y},{5, y}] # Row
			1 -> [{2, y+1},{3, y},{3, y+1},{3, y+2},{4, y+1}] # Plus
			2 -> [{2, y},{3, y},{4, y},{4, y+1}, {4, y+2}] # Backwards L
			3 -> [{2, y},{2, y+1},{2, y+2},{2, y+3}] # Column
			4 -> [{2, y},{3, y},{2, y+1},{3, y+1}] # Square
		end
	end

end