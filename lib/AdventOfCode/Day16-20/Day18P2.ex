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
		queue = [{@myminbound,@myminbound,@myminbound}]
		run(list, mapset, queue, MapSet.new(), 0)
	end

	def run(list, mapset, [], visited, score) do score end
	def run(list, mapset, queue, visited, score) do
		[head|rest] = queue 

		#Calculate score
		tempscore = cond do
			MapSet.member?(mapset, head) and !MapSet.member?(visited, head) ->
				getScore(head, mapset)
			true -> 0
		end
		score = score + tempscore

		
		#Get neighboring nodes
		neighbours = cond do
			tempscore == 0 and !MapSet.member?(mapset, head) -> getNeighbors(head, visited)
			true -> []
		end

		#Add head to visited
		visited = MapSet.put(visited, head)

		#Add neigbors to queue
		queue = Enum.filter(rest++neighbours, fn(x)-> !MapSet.member?(visited, x) end)

		#Run function again
		run(list, mapset, queue, visited, score)
	end

	#This function is wrong. Need to change this function. 
	def getScore({x,y,z}, mapset) do
		neighbours = [{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}]
		Enum.reduce(neighbours, 6, fn(x, acc)-> case MapSet.member?(mapset, x) do
			true -> acc-1; false -> acc; end end)
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

end