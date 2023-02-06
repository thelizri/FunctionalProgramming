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
			rate > 0 -> create_unvisited_nodes_list(rest, [{letter, rate}|result])
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
		matrix = step3(matrix, length(list))
		execute_final(list, unvisited, map, matrix)
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

	def step3(matrix, vertices) do
		loop( 0, 0, 0, vertices, matrix, :k)
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
			{:infinity, :infinity, :infinity} -> matrix
			{:infinity, :infinity, _} -> matrix
			{:infinity, _, :infinity} -> matrix
			{:infinity, _, _} -> Matrix.set(matrix, i, j, b+c)
			{_, :infinity, _} -> matrix
			{_, _, :infinity} -> matrix
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

	######################################################################################################
	# Finished implementing algorithm. Time to solve the puzzle

	def execute_final(list, unvisited, map, matrix) do
		#get_list_of_scores(:A, unvisited, [], map, matrix, 30)
		#|> get_max_score_from_list(30, nil)
		#unvisited = remove_from_unvisited(unvisited, :D)
		#get_list_of_scores(:D, unvisited, [], map, matrix, 28)
		#unvisited = remove_from_unvisited(unvisited, :B)
		#get_list_of_scores(:B, unvisited, [], map, matrix, 25)
		#unvisited = remove_from_unvisited(unvisited, :J)
		#get_list_of_scores(:J, unvisited, [], map, matrix, 21)
		#unvisited = remove_from_unvisited(unvisited, :H)
		#get_list_of_scores(:H, unvisited, [], map, matrix, 13)
		do_a_step(list, unvisited, map, matrix, 30, :A, 0)
	end

	def get_list_of_scores(starting_node, [], result, map, matrix, time) do
		result
	end

	def get_list_of_scores(starting_node, [unvisited|rest], result, map, matrix, time) do
		{to, rate} = unvisited
		{score, total_time, mod} = calculate_score_of_node(starting_node, to, rate, map, matrix, time)
		get_list_of_scores(starting_node, rest, [{to, score, total_time, mod}|result], map, matrix, time)
	end

	def get_max_score_from_list([], time_left, result) do result end

	def get_max_score_from_list([head|rest], time_left, result) do
		{to, score, total_time, mod} = head
		case result do
			nil -> 
				cond do 
					total_time <= time_left -> get_max_score_from_list(rest, time_left, head) #Can cause error
					true -> get_max_score_from_list(rest, time_left, result)
				end
			_ -> 
				{_, _, _, modMax} = result
				cond do
					total_time > time_left -> get_max_score_from_list(rest, time_left, result)
					mod > modMax -> get_max_score_from_list(rest, time_left, head)
					true -> get_max_score_from_list(rest, time_left, result)
				end
		end
	end

	def calculate_score_of_node(from, to, flowrate, map, matrix, time) do
		{:ok, row} = Map.fetch(map, from)
		{:ok, col} = Map.fetch(map, to)
		time_to_get_to_location = Matrix.elem(matrix, row, col)
		time_to_open_valve = 1
		total_time = time_to_get_to_location + time_to_open_valve
		score = flowrate*(time-time_to_get_to_location-time_to_open_valve)
		{score, total_time, score/total_time/total_time}
	end

	def remove_from_unvisited(unvisited, remove) do
		Enum.filter(unvisited, fn(x) -> {node, _} = x; node != remove end)
	end

	def do_a_step(list, [], map, matrix, time, current_node, result) do result end

	def do_a_step(list, unvisited, map, matrix, time, current_node, result) do
		{node, score, time_taken,_} = get_list_of_scores(current_node, unvisited, [], map, matrix, time)
		|> get_max_score_from_list(time, nil)
		:io.write({node, score, time_taken})
		IO.puts("    <- Step")
		unvisited = remove_from_unvisited(unvisited, node)
		result = result + score
		current_node = node
		time = time - time_taken
		cond do 
			time > 0 -> do_a_step(list, unvisited, map, matrix, time, current_node, result)
			true -> result
		end
	end

	# How to solve day 16
	# Disregard all nodes with valve rates equal to zero
	# Score of a node = valve_rate*(time_left-time_to_get_there)
	# Pick node with highest score. Move to it. Open valve.
	# Repeat.

end