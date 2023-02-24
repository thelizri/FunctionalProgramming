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
		run(list, mapset, MapSet.new(), 0)
	end

	def run([], mapset, visited, score) do score end
	def run([head|rest], mapset, visited, score) do
		#Calculate score
		tempscore = cond do
			MapSet.member?(mapset, head) and !MapSet.member?(visited, head) ->
				getScore(head, mapset)
			true -> 0
		end
		score = score + tempscore

		#Add head to visited
		visited = MapSet.put(visited, head)

		#Run function again
		run(rest, mapset, visited, score)
	end

	#This function is wrong. Need to change this function. 
	def getScore({x,y,z}, mapset) do
		[{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}] |>
		Enum.filter(fn(x)-> MapSet.member?(mapset, x) end) |> 
		Enum.map(fn(coord)-> dfs(coord, mapset, MapSet.new([coord])) end) |> List.flatten() 
		|> Enum.count(fn(x)-> x end)
	end

	def getNeighbors({x,y,z}, visited) do
		neighbours = [{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}]
		Enum.filter(neighbours, fn({x,y,z})-> x<=@mymaxbound and x>=@myminbound 
			and y<=@mymaxbound and y>=@myminbound and z<=@mymaxbound and z>=@myminbound end)
		|> Enum.filter(fn({x,y,z})-> !MapSet.member?(visited, {x,y,z}) end)
	end


	#BFS (G, s)                   //Where G is the graph and s is the source node
    #  let Q be queue.
    #  Q.enqueue( s ) //Inserting s in queue until all its neighbour vertices are marked.
	#
    #  mark s as visited.
    #  while ( Q is not empty)
    #       //Removing that vertex from queue,whose neighbour will be visited now
    #       v  =  Q.dequeue( )
	#
    #      //processing all the neighbours of v  
    #      for all neighbours w of v in Graph G
    #           if w is not visited 
    #                    Q.enqueue( w )             //Stores w in Q to further visit its neighbour
    #                    mark w as visited.

    #We will use depth first search to calculate the score
    def dfs({x,y,z}, mapset, visited) when x > @mymaxbound or x < @myminbound do true end
    def dfs({x,y,z}, mapset, visited) when y > @mymaxbound or y < @myminbound do true end
    def dfs({x,y,z}, mapset, visited) when z > @mymaxbound or z < @myminbound do true end

    def dfs({x,y,z}, mapset, visited) do
    	list = [{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}]
    	|> Enum.filter(fn(x)-> !MapSet.member?(mapset, x) and !MapSet.member?(visited, x) end)
    	visited = Enum.reduce(list, visited, fn(x, acc)-> MapSet.put(acc, x) end)
    	check(list, mapset, visited)
    end

    def check([], mapset, visited) do false end
    def check([head|rest], mapset, visited) do
    	case Enum.any?([dfs(head, mapset, visited)]) do
    		true -> true
    		false -> check(rest, mapset, visited)
    	end
    end

end