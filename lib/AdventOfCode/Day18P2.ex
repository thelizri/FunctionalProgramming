#Flood fill algorithm
defmodule Day18P2 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day18.txt")
		String.split(content, "\r\n")
		|> Enum.map(fn(x)-> [a, b, c] = String.split(x, ",", trim: true); {String.to_integer(a), String.to_integer(b), String.to_integer(c)} end)
	end

	def main() do
		list = read()
		mapset = MapSet.new(list)

		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)
		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)
		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)
		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)
		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)
		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)
		mapset = floodAll(list, mapset)
		list = MapSet.to_list(mapset)

		getArea(MapSet.to_list(mapset))
	end

	#Returns -1 if neighbor. Otherwise returns 0
	def isNeighbor({x,y,z}, other) do
		case1 = {x+1,y,z}; case2 = {x-1,y,z}
		case3 = {x,y+1,z}; case4 = {x,y-1,z}
		case5 = {x,y,z+1}; case6 = {x,y,z-1}
		case other do
			^case1 -> -1; ^case2 -> -1
			^case3 -> -1; ^case4 -> -1
			^case5 -> -1; ^case6 -> -1
			_ -> 0
		end
	end

	def getArea(list) do 
		Enum.reduce(list, 0, fn(x, acc)-> acc+getScore(x, list)end)
	end

	def getScore(coord, list) do
		Enum.reduce(list, 6, fn(x, acc)-> acc + isNeighbor(coord, x) end)
	end

	def isInside({x,y,z}, mapset) do
		right = Enum.reduce(1..10, false, fn(n, acc)-> case acc do true -> true; false -> MapSet.member?(mapset, {x+n,y,z}) end end)
		left = Enum.reduce(1..10, false, fn(n, acc)-> case acc do true -> true; false -> MapSet.member?(mapset, {x-n,y,z}) end end)
		front = Enum.reduce(1..10, false, fn(n, acc)-> case acc do true -> true; false -> MapSet.member?(mapset, {x,y+n,z}) end end)
		behind = Enum.reduce(1..10, false, fn(n, acc)-> case acc do true -> true; false -> MapSet.member?(mapset, {x,y-n,z}) end end)
		top = Enum.reduce(1..10, false, fn(n, acc)-> case acc do true -> true; false -> MapSet.member?(mapset, {x+n,y,z+n}) end end)
		bottom = Enum.reduce(1..10, false, fn(n, acc)-> case acc do true -> true; false -> MapSet.member?(mapset, {x-n,y,z-n}) end end)
		case {right, left, front, behind, top, bottom} do
			{true, true, true, true, true, true} -> true
			_ -> false
		end
	end

	def floodFill({x,y,z}, mapset) do
		cond do
			isInside({x,y,z}, mapset) -> MapSet.put(mapset, {x,y,z})
			true -> mapset
		end
	end

	def floodAll([], mapset) do mapset end
	def floodAll([rock|rest], mapset) do
		adj = getAdj(rock)
		mapset = Enum.reduce(adj, mapset, fn(rrock, acc)->case MapSet.member?(mapset, rrock) do true -> acc; false -> floodFill(rrock, acc) end end)
		floodAll(rest, mapset)
	end

	def getAdj({x,y,z}) do
		[{x+1,y,z}, {x-1,y,z}, {x,y+1,z}, {x,y-1,z}, {x,y,z+1}, {x,y,z-1}]
	end

end