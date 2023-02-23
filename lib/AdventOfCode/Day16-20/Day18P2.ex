#Flood fill algorithm
defmodule Day18P2 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day16-20/Day18.txt")
		String.split(content, "\r\n")
		|> Enum.map(fn(x)-> [a, b, c] = String.split(x, ",", trim: true); {String.to_integer(a), String.to_integer(b), String.to_integer(c)} end)
	end

	def main() do
		list = read()
		mapset = MapSet.new(list)
		queue = [{0,0,0}]
		run(list, mapset, queue, MapSet.new(), 0)
	end

	def run(list, mapset, [], visited, score) do score end
	def run(list, mapset, queue, visited, score) do
		[head|rest] = queue 

		#Calculate score
		score = cond do
			MapSet.member?(mapset, head) and !MapSet.member?(visited, head) ->
				score + getScore(head, list)
			true -> score
		end

		#Get neighboring nodes
		neighbours = cond do
			MapSet.member?(mapset, head) -> []
			true -> getNeighbors(head, visited)
		end

		#Add head to visited
		visited = MapSet.put(visited, head)

		#Add neigbors to queue
		queue = Enum.filter(queue++neighbours, fn(x)-> !MapSet.member?(visited, x) end)

		#Run function again
		run(list, mapset, queue, visited, score)
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

	def getNeighbors({x,y,z}, visited) do
		neighbours = [{x+1,y,z}, {x,y+1,z}, {x,y,z+1}, {x-1,y,z}, {x,y-1,z}, {x,y,z-1}]
		Enum.filter(neighbours, fn({x,y,z})-> x<=21 and x>=0 and y<=21 and y>=0 and z<=21 and z>=0 end)
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