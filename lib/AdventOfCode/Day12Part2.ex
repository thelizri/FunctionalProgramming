defmodule Day12Part2 do

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

	def getAdjacent(index, dim) do
		up = getUp(index, dim)
		down = getDown(index, dim)
		left = getLeft(index, dim)
		right = getRight(index, dim)
		Enum.filter([up, down, left, right], fn(x)-> case x do :error->false; _ -> true; end end)
	end

	def getNeighbors(from, [], map, results) do results end
	def getNeighbors(from, [head|rest], map, results) do
		heightFrom = elem(map, from)
		heightTo = elem(map, head)
		cond do
			heightFrom >= heightTo-1 -> getNeighbors(from, rest, map, results ++ [head])
			true ->  getNeighbors(from, rest, map, results)
		end
	end

	def initProgram(content) do
		rows = splitRows(content)
		dim = getDimensions(rows)
		list = Enum.map(rows, fn(x)->String.to_charlist(x) end)
		|> List.flatten
		destination = Enum.find_index(list, fn(x)-> x == 69 end)
		map = Enum.map(list, fn(x)-> case x do 83 -> 97; 69 -> 122; _ -> x; end end) |> List.to_tuple
		length = length(list)
		matrix = Matrix.new(length, length, nil)
		Enum.to_list(0..(length-1)) |> Enum.reduce(matrix, fn(x, acc)-> Matrix.set(acc, x, x, 0) end)
	end

	def returnMin(value1, value2) do
		case {value1, value2} do
			{nil, nil} -> nil
			{nil, value2} -> value2
			{value1, nil} -> value1
			{value1, value2} -> cond do value1 < value2 -> value1; true -> value2; end
		end
	end


	# Floyd-Warshall Algorithm
	# let V = number of vetrices in graph
	# let dist = V * V array of minimum distances
	# for each vertex v
	# 	dist[v][v] <- 0
	# for each edge (u,v)
	# 	dist[u][v] <- weight(u,v)
	# for k from 1 to V
	# 	for i from 1 to V
	# 		for j from 1 to V
	# 			if dist[i][j] > dist[i][k] + dist[k][j]
	#				dist[i][j] <- dist[i][k] + dist[k][j]
	#			end if

end