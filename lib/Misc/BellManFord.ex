defmodule BellmanFord do

	def main() do
		map = %{:s => 0, :a => :infinity, :b => :infinity, :c => :infinity, :d => :infinity, :e => :infinity,}
		s = [:s, {:a, 10}, {:e, 8}]
		a = [:a, {:c, 2}]
		b = [:b, {:a, 1}]
		c = [:c, {:b, -2}]
		d = [:d, {:a, -4}, {:c, -1}]
		e = [:e, {:d, 1}]
		nodes = [s, a, b, c, d, e]
		iterate(map, nodes, 5)
	end

	def iterate(map, nodes, iteration) when iteration > 0 do
		map = algo(map, nodes)
		iterate(map, nodes, iteration-1)
	end

	def iterate(map, nodes, iteration) do
		map
	end

	def algo(map, []) do
		map
	end

	def algo(map, [head|rest]) do
		[current_node|links] = head
		current_distance = map[current_node]
		if current_distance == :infinity do
			algo(map, rest)
		else
			local_map = for {a, b} <- links do
				{a, b+current_distance}
			end
			update_map(map, local_map)
			|> algo(rest)
		end
	end

	def update_map(map, []) do
		map
	end

	def update_map(map, [head|rest]) do
		{node, distance} = head
		map_distance = map[node]
		map = cond do
			map_distance == :infinity -> Map.replace(map, node, distance)
			distance < map_distance -> Map.replace(map, node, distance)
			true -> map
		end
		update_map(map, rest)
	end

end