defmodule EnvTree do 
	def new() do
		nil
	end

	def add(nil, key, value) do
		{:node, key, value, nil, nil}
	end

	def add({:node, key, _, left, right}, key, value) do
		{:node, key, value, left, right}
	end

	def add({:node, k, v, left, right}, key, value) when key < k do
		{:node, k, v, add(left, key, value), right}
	end

	def add({:node, k, v, left, right}, key, value) do
		{:node, k, v, left, add(right, key, value)}
	end

	def lookup(nil, _key) do 
		nil
	end

	def lookup({:node, key, value, _left, _right}, key) do
		{key, value}
	end

	def lookup({:node, k, _v, left, _right}, key) when key < k do
		lookup(left, key)
	end

	def lookup({:node, _k, _v, _left, right}, key) do
		lookup(right, key)
	end

	def remove(nil, _) do nil end

	def remove({:node, key, _, nil, right}, key) do
		right
	end

	def remove({:node, key, _, left, nil}, key) do
		left
	end

	#def remove({:node, key, _, left, right}, key) do

	def leftmost({:node, key, value, nil, _}) do
		{key, value}
	end

	def leftmost({:node, _, _, left, _}) do
		leftmost(left)
	end

	def rightmost({:node, key, value, _, nil}) do
		{key, value}
	end

	def rightmost({:node, key, value, _, right}) do
		rightmost(right)
	end


end

defmodule EnvList do

	def new() do
		[]
	end

	def add([], key, value) do
		[{key, value}]
	end

	def add(map, key, value) do
		[{key, value}|map]
	end

	def lookup([], _key) do
		nil
	end

	def lookup([{key, value}|_rest], key) do
		{key, value}
	end

	def lookup([{_k, _}|rest], key) do
		lookup(rest, key)
	end

	def remove([], _key) do
		nil
	end

	def remove([{key, value}|rest], key) do
		rest
	end

	def remove([head|rest], key) do
		[head|remove(rest, key)] 
	end

end 