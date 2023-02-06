defmodule Day16 do
	#30 minutes before the volcano erupts
	#All tunnels take one minute to travel through
	#Each valve takes one minute to open

	def read() do
		{_, content} = File.read("lib/AdventOfCode/Day16.txt")
		list = String.split(content, "\r\n") |> parse_row([])
		matrix = create_matrix(list)
		unvisited = create_unvisited_nodes_list(list)
		map = create_hash_map()
		execute_program(list, unvisited, map, matrix)
	end

	def parse_row([], results) do
		Enum.reverse(results)
	end

	def parse_row([head|rest], results) do
		nodes = Regex.scan(~r/\s*[A-Z]{2}\s*/, head) 
		|> Enum.map(fn(x) -> [y] = x; y = String.trim(y); String.at(y, 0) end)
		|> List.flatten
		[node|links] = for node <- nodes do
			String.trim(node) |> String.to_atom()
		end
		number = Regex.scan(~r/\d+/, head) |> List.flatten |> Enum.at(0) |> String.to_integer
		parse_row(rest, [{node, number, links}|results])
	end

	def create_matrix(list) do
		size = length(list)
		Matrix.new(size, size, :infinity)
	end

	def create_unvisited_nodes_list(list, result \\ [])
	def create_unvisited_nodes_list([], result) do result end
	def create_unvisited_nodes_list([head|rest], result) do
		{letter, rate, _} = head
		cond do
			rate > 0 -> create_unvisited_nodes_list(rest, [letter|result])
			true -> create_unvisited_nodes_list(rest, result)
		end
	end

	def create_hash_map() do
		string = String.split("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "", trim: true)
		map = Map.new()
		Enum.reduce(string, map, fn(x, acc) -> Map.put(acc, String.to_atom(x), :binary.first(x)-65) end)
	end

	######################################################################################################
	# Done with parsing data. Time to implement algorithm

	def execute_program(list, unvisited, map, matrix) do
		matrix = step1(matrix, length(list))
		matrix = step2(matrix, list, map)
	end

	#While i < vertices - 1
	def step1(matrix, vertices, i \\ 0) do
		matrix = Matrix.set(matrix, i, i, 0)
		cond do i < vertices - 1 -> step1(matrix, vertices, i+1); true -> matrix; end
	end

	def step2(matrix, list, map) do
		weights = get_weight_list(list, map, [])
		loop_through_weights(matrix, weights)
	end

	#For step 2
	def get_weight_list([], map, result) do List.flatten(result) end
	#For step 2
	def get_weight_list([head|rest], map, result) do
		{from, _, to} = head
		{:ok, from} = Map.fetch(map, from)
		new = for item <- to do
			{:ok, tto} = Map.fetch(map, item)
			{from, tto}
		end
		get_weight_list(rest, map, [new|result])
	end

	#For step 2
	def loop_through_weights(matrix, []) do matrix end
	def loop_through_weights(matrix, [weight|rest]) do
		{row, col} = weight
		loop_through_weights(Matrix.set(matrix, row, col, 1), rest)
	end


	#For step 3. Nested loop
	#While k < length-1, i < length-1, j < length-1 
	def loop(k, i, j, length, result, :k) do
		result = loop(k, i, j, length, result, :i)
		cond do k < length-1 -> loop(k+1, i, j, length, result, :k); true -> result; end
	end

	def loop(k, i, j, length, result, :i) do
		result = loop(k, i, j, length, result, :j)
		cond do i < length-1 -> loop(k, i+1, j, length, result, :i); true -> result; end
	end

	def loop(k, i, j, length, result, :j) do
		:io.write({k,i,j})
		IO.puts("  <- Value")
		cond do j < length-1 -> loop(k, i, j+1, length, result, :j); true -> result; end
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

	# How to solve day 16
	# Disregard all nodes with valve rates equal to zero
	# Score of a node = valve_rate*(time_left-time_to_get_there)
	# Pick node with highest score. Move to it. Open valve.
	# Repeat.

end