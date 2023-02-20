defmodule Day18 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day18.txt")
		String.split(content, "\r\n")
		|> Enum.map(fn(x)-> [a, b, c] = String.split(x, ",", trim: true); {String.to_integer(a), String.to_integer(b), String.to_integer(c)} end)
	end

	def main() do
		list = read()
		Enum.reduce(list, 0, fn(x, acc)-> acc+getScore(x, list) end)
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

	def getScore(coord, list) do
		Enum.reduce(list, 6, fn(x, acc)-> acc + isNeighbor(coord, x) end)
	end


end