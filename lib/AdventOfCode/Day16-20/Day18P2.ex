#Flood fill algorithm
defmodule Day18P2 do
	@mymaxbound 6
	@myminbound 1

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
		|> Enum.map(fn(coord)-> dfs(coord, mapset, MapSet.new()) end)
		|> Enum.filter(fn(res)-> res end)
		|> Enum.count()
	end

	 #We will use depth first search to calculate the score
    def dfs({x,y,z}, mapset, visited) when x > @mymaxbound or x < @myminbound do true end
    def dfs({x,y,z}, mapset, visited) when y > @mymaxbound or y < @myminbound do true end
    def dfs({x,y,z}, mapset, visited) when z > @mymaxbound or z < @myminbound do true end

    def dfs(coord={x,y,z}, mapset, visited) do
    	cond do
    		MapSet.member?(visited, coord) -> false
    		MapSet.member?(mapset, coord) -> false
    		true ->
    		visited = MapSet.put(visited, coord)
    		neighbors = [{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}]
    		|> Enum.filter(fn(pos)-> !MapSet.member?(mapset, pos) and !MapSet.member?(visited, pos) end)
    		|> Enum.map(fn(pos)-> dfs(pos, mapset, visited) end)
    		|> Enum.any?()
    	end
    end

end