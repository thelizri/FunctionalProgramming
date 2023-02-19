# seven units wide
# Three units above the highest rock
# Two units away from the left wall

defmodule Day17P2 do

	#Answer = 1569054441243
	#Delta round = 1745
	#Height = 2738
	# Score at round 2754 = 4305
	# Formula: score = div(trillion-1446, 1745)*2738+4305
	def calc() do
		trillion = 1000000000000
		cycles = div(trillion-1446, 1745) |> IO.inspect
		not_final_score = cycles*2738 |> IO.inspect
		second = trillion - 1745*cycles |> IO.inspect # The round we need to check. Equal to 2755. 
		final_score = not_final_score+4305 |> IO.inspect
	end

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day17.txt")
		list = String.to_charlist(content) |> List.to_tuple
		blizzards = {-1, list}
		mapset = MapSet.new([{0,0},{1,0},{2,0},{3,0},{4,0},{5,0},{6,0}])
		run(0, mapset, blizzards, 0)
	end

	# Main program
	def run(round, mapset, blizzards, themax) when round < 2755 do
		max_y = getTopMost(MapSet.to_list(mapset))
		rock = getRock(round, max_y)
		{mapset, blizzards, themax} = move(round, rock, mapset, blizzards, themax)
		mapset = filterMapSet(mapset, themax, round)
		run(round+1, mapset, blizzards, themax)
	end

	def run(_num, mapset, _blizzards, themax) do
		getTopMost(mapset)
	end

	def move(round, rock, mapset, blizzards, themax) do
		{direction, blizzards} = getNextBlizzardDirection(blizzards)
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
			true -> {Enum.reduce(rock, mapset, fn(pos, acc)-> MapSet.put(acc, pos) end), blizzards, max(getTopMost(newRock), themax)}
			false -> move(round, newRock, mapset, blizzards, themax)
		end
	end

	# Movement
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

	def getTopMost(list) do
		Enum.reduce(list, -1, fn({x,y}, acc)-> max(y, acc) end)
	end
	def getLeftMost(list) do
		Enum.reduce(list, 100, fn({x,y}, acc)-> min(x, acc) end)
	end
	def getRightMost(list) do
		Enum.reduce(list, -100, fn({x,y}, acc)-> max(x, acc) end)
	end

	# Other functions
	def getNextBlizzardDirection({index, list}) do
		size=tuple_size(list)
		index = rem(index+1, size)
		{elem(list, index), {index, list}}
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

	def isOccupied([], mapset) do false end
	def isOccupied([pos|rest], mapset) do
		case MapSet.member?(mapset, pos) do
			true -> true
			false -> isOccupied(rest, mapset)
		end
	end

	def filterMapSet(mapset, themax, round) do
		bottom = getMaxCompleteRow(mapset, themax)
		height = getTopMost(mapset)
		prevBottom = Enum.reduce(MapSet.to_list(mapset), nil, fn({x,y}, acc)-> case acc do nil -> y; _ -> min(y, acc); end end)
		cond do 
			bottom == prevBottom -> nil
			true -> IO.puts("New bottom: #{bottom}, Previous bottom: #{prevBottom}. Difference #{abs(bottom-prevBottom)}. Round #{round}. Height #{height}")
		end
		MapSet.to_list(mapset) |> Enum.filter(fn({x, y})-> y >= bottom end) |> MapSet.new()
	end

	def getMaxCompleteRow(mapset, themax) do
		Enum.find(themax..0, fn(row)-> checkIfRowComplete(mapset, row) end)
	end

	def checkIfRowComplete(mapset, row) do
		cond do
			!MapSet.member?(mapset, {0, row}) -> false
			!MapSet.member?(mapset, {1, row}) -> false
			!MapSet.member?(mapset, {2, row}) -> false
			!MapSet.member?(mapset, {3, row}) -> false
			!MapSet.member?(mapset, {4, row}) -> false
			!MapSet.member?(mapset, {5, row}) -> false
			!MapSet.member?(mapset, {6, row}) -> false
			true -> true
		end
	end

end