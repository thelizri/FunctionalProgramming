defmodule Floyd do

	def test() do
		for k <- 1..3, i <- 1..3, j <- 1..3 do
			{k, i, j}
		end
	end

	def test2() do
		loop( 0, 0, 0, 2, nil, :k)
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
end