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
		start = Enum.find_index(list, fn(x)-> x == 83 end)
		map = Enum.map(list, fn(x)-> case x do 83 -> 97; 69 -> 122; _ -> x; end end) |> List.to_tuple
		length = length(list)
		matrix = Matrix.new(length, length, nil)
		matrix = Enum.to_list(0..(length-1)) |> Enum.reduce(matrix, fn(x, acc)-> Matrix.set(acc, x, x, 0) end)
		executeProgram(matrix, map, destination, start, dim)
	end

	def returnMin(value1, value2) do
		case {value1, value2} do
			{nil, nil} -> nil
			{nil, value2} -> value2
			{value1, nil} -> value1
			{value1, value2} -> cond do value1 < value2 -> value1; true -> value2; end
		end
	end

	def executeProgram(matrix, map, destination, start, dim) do
		length = Enum.to_list(0..(tuple_size(map)-1))
		matrix = updateMatrix(matrix, map, dim, length)
		matrix = step3(matrix, tuple_size(map))
		Matrix.elem(matrix, start, destination)
	end

	def updateMatrix(matrix, map, dim, []) do matrix end
	def updateMatrix(matrix, map, dim, [index|rest]) do
		adj = getAdjacent(index, dim)
		neighbors = getNeighbors(index, adj, map, [])
		matrix = Enum.reduce(neighbors, matrix, fn(x, acc) -> Matrix.set(acc, index, x, 1) end)
		matrix = updateMatrix(matrix, map, dim, rest)
	end

	def step3(matrix, length) do
		loop(0, 0, 0, length, matrix, :k)
	end

	#For step 3. Nested loop
	#While k < length-1, i < length-1, j < length-1 
	def loop(k, i, j, length, matrix, :k) do
		matrix = loop(k, i, j, length, matrix, :i)
		cond do k < length-1 -> loop(k+1, i, j, length, matrix, :k); true -> matrix; end
	end

	def loop(k, i, j, length, matrix, :i) do
		matrix = loop(k, i, j, length, matrix, :j)
		cond do i < length-1 -> loop(k, i+1, j, length, matrix, :i); true -> matrix; end
	end

	def loop(k, i, j, length, matrix, :j) do
		a = Matrix.elem(matrix, i, j)
		b = Matrix.elem(matrix, i, k)
		c = Matrix.elem(matrix, k, j)
		matrix = case {a,b,c} do
			{nil, nil, nil} -> matrix
			{nil, nil, _} -> matrix
			{nil, _, nil} -> matrix
			{nil, _, _} -> Matrix.set(matrix, i, j, b+c)
			{_, nil, _} -> matrix
			{_, _, nil} -> matrix
			{_, _, _} -> cond do a > b + c -> Matrix.set(matrix, i, j, b+c); true -> matrix; end
		end
		cond do j < length-1 -> loop(k, i, j+1, length, matrix, :j); true -> matrix; end
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