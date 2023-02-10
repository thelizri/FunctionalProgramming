defmodule Day12 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day12.txt")
		initProgram(content)
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

	#E = 69
	def getDestinationIndex(list) do
		Enum.find_index(list, fn(x)-> x == 69 end)
	end

	def replaceStartAndDestWithHeight(list) do
		Enum.map(list, fn(x)-> case x do 69 -> 122; 83 -> 97; _ -> x; end end)
	end

	def createMapOfDistances(list, to) do
		Enum.to_list(0..(length(list)-1)) |>
		Enum.reduce(Map.new(), fn(x, map) -> Map.put(map, x, {:infinity, nil}) end) |>
		Map.put(to, {0, nil})
	end

	def initProgram(content) do
		rows = splitRows(content)
		dim = getDimensions(rows)
		list = convertToList(rows) |> convertListOfCharactersToNumbers
		{from, to} = {getStartIndex(list), getDestinationIndex(list)}
		list = replaceStartAndDestWithHeight(list)
		distances = createMapOfDistances(list, to)
		unvisited = distances
		executeProgram(distances, unvisited, {from, to}, dim, List.to_tuple(list), length(list)-1)
	end
#######################################################################################################################################
# Let's start executing the program

	def getClosestUnvisited(unvisited) do
		index = Enum.reduce(Map.keys(unvisited), fn(x, acc) -> {ans, _} = findMin({x, fetch(unvisited, x)}, {acc, fetch(unvisited, acc)}); ans end)
		{index, fetch(unvisited, index)}
	end

	def findMin(first = {vertexA, {distanceA, _}}, second = {vertexB, {distanceB, _}}) do
		cond do
			distanceA == :infinity -> second
			distanceB == :infinity -> first
			distanceA <= distanceB -> first
			true -> second
		end
	end

	def fetch(map, x) do
		{:ok, ans} = Map.fetch(map, x)
		ans
	end

	def executeProgram(distances, unvisited, fromTo, dim, height, length) when length > -1 do
		isAdjacent(21, height, dim)
		#executeProgram(distances, unvisited, fromTo, dim, height, length-1)
	end

	def executeProgram(distances, _, {from, to}, _, _, _) do {dis, _} = fetch(distances, from); dis end

	def getUp(index, {row, col}) do
		index = index-col
		cond do index < 0 -> :error; true -> index; end
	end

	def getDown(index, {row, col}) do
		length=row*col;
		index = index+col
		cond do index >= length -> :error; true -> index; end
	end

	def getRight(index, {row, col}) do
		index = index+1
		cond do rem(index, col) == 0 -> :error; true -> index; end
	end

	def getLeft(index, {row, col}) do
		cond do rem(index, col) == 0 -> :error; true -> index - 1; end
	end

	def isAdjacent(index, heightTuple, dim) do
		height = elem(heightTuple, index)
		heightUp = elem(heightTuple, getUp(index, dim))
		heightDown = elem(heightTuple, getDown(index, dim))
		heightLeft = elem(heightTuple, getLeft(index, dim))
		heightRight = elem(heightTuple, getRight(index, dim))
		list = [heightUp, heightDown, heightLeft, heightRight]
		Enum.filter(list, fn(x)->cond do x >= height-1 -> true; true -> false; end end)
	end

	def calcDistanceToNeighbors(currentPosition, neighbours, distances) do
		
	end


end

# Djikstra's Algorithm
# Let distance of start vertex from start vertex = 0
# Let distance of all other vertices from start = infinity
#
# Repeat
# 	Visit the unvisited vertex with the smallest known distance from the start vertex
# 	For the current vertex, examine its unvisited neighbours
#	For the current vertex, calculate distance of each neighbour from start vertex
# 	If the calculated distance of a vertex is less thna the known distance, update the shortest distance
#	Update the previous vertex for each of the updated distances
# 	Add the current vertex to the list of visited vertices
# Until all vertices visited