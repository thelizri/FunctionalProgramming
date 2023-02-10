defmodule Day12 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day12.txt")
		executeProgram(content)
	end

	def executeProgram(content) do
		rows = splitRows(content)
		dim = getDimensions(rows) |> IO.inspect
		list = convertToList(rows) |> IO.inspect |> convertListOfCharactersToNumbers
		{from, to} = {getStartIndex(list), getDestinationIndex(list)}
	end

	def splitRows(content) do
		rows = String.split(content, "\r\n")
	end

	def getDimensions(rows) do
		num_rows = length(rows)
		[head|rest] = rows
		num_columns = String.split(head, "", trim: true) |> length
		{num_rows, num_columns}
	end

	def convertToList(rows) do
		Enum.map(rows, fn(x)->String.split(x, "", trim: true) end)
		|> List.flatten
	end

	def convertListOfCharactersToNumbers(list) do
		for letter <- list do
			<<value::utf8>> = letter; value
		end
	end

	#S = 83
	def getStartIndex(list) do
		Enum.find_index(list, fn(x)-> x == 83 end)
	end

	#E = 
	def getDestinationIndex(list) do
		Enum.find_index(list, fn(x)-> x == 69 end)
	end

end

# function Dijkstra(Graph, source):
#     
#     for each vertex v in Graph.Vertices:
#         dist[v] ← INFINITY
#         prev[v] ← UNDEFINED
#         add v to Q
#     dist[source] ← 0
#     
#     while Q is not empty:
#         u ← vertex in Q with min dist[u]
#         remove u from Q
#         
#         for each neighbor v of u still in Q:
#             alt ← dist[u] + Graph.Edges(u, v)
#             if alt < dist[v]:
#                 dist[v] ← alt
#                 prev[v] ← u
#     return dist[], prev[]