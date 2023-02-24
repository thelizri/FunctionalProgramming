defmodule Day18 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day16-20/Day18.txt")
		String.split(content, "\r\n")
		|> Enum.map(fn(x)-> [a, b, c] = String.split(x, ",", trim: true); {String.to_integer(a), String.to_integer(b), String.to_integer(c)} end)
	end

	def main() do
		list = read() 
		mapset = MapSet.new(list)
		Enum.reduce(list, 0, fn(x, acc)-> acc+getScore(x, mapset) end)
	end

	def getScore({x,y,z}, mapset) do
		[{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}]
		|> Enum.filter(fn(coord)-> !MapSet.member?(mapset, coord) end)
		|> Enum.count()
	end


end