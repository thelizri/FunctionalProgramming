defmodule ExperimentGraphs do

	def test() do
		g = Graph.new(type: :undirected) |> Graph.add_edges([{:a, :b, weight: 6}, {:a, :d, weight: 1},
		 {:b, :d, weight: 2}, {:b, :e, weight: 2}, {:b, :c, weight: 5},
		  {:e, :c, weight: 5}, {:d, :e, weight: 1}])
		Graph.bellman_ford(g, :a)
	end

end