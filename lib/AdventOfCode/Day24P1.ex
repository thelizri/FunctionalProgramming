defmodule Day24P1 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day24.txt")
	end

	def enqueue(list, node) do
		[node | list]
	end

	def dequeue(list) do
		res = List.last(list)
		list = List.delete_at(list, -1)
		{res, list}
	end

	# BFS(graph, start_node):
    # create a queue Q
    # mark the start_node as visited and enqueue it into Q
    # while Q is not empty:
    #     dequeue a node from Q and call it current_node
    #      for each neighbor of current_node:
    #         if neighbor is not visited:
    #             mark neighbor as visited and enqueue it into Q#

end