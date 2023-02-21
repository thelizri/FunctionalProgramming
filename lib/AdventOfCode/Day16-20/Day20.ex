defmodule Day20 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day20.txt")
		{list, _} = String.split(content, "\r\n", trim: true)
		|> Enum.map(fn(x)-> String.to_integer(x) end)
		|> Enum.reduce({[],0},fn(x, {list, index})-> {list ++ [{x, index}], index+1} end)
		execute(list)
	end

	def execute(list) do
		length = length(list)-1
		list = Enum.reduce(0..length, list, fn(x, acc)->moveElem(acc, x) end)
		|> present()
		sum(list)
	end


	def present(list) do
		Enum.map(list, fn({val, pos}) -> val end)
	end

	def sum(list) do
		s1 = getAt(1000, list)
		s2 = getAt(2000, list)
		s3 = getAt(3001, list)
		s1+s2+s3
	end

	def moveElem(list, index) do
		length = length(list)
		position = Enum.find_index(list, fn({val, pos})-> pos == index end)
		{:ok, tuple} = Enum.fetch(list, position)
		{value, _} = tuple
		val = Integer.mod(value, length)
		newPos = cond do
			value < 0 -> Integer.mod(val+position, length)
			true -> Integer.mod(val+position, length) + 1
		end
		list = List.replace_at(list, position, nil)
		list = List.insert_at(list, newPos, tuple)
		list = Enum.filter(list, fn(x) -> x != nil end)
	end

	def getAt(num, list) do
		length = length(list)
		index = Integer.mod(num, length)
		start = Enum.find_index(list, fn(x)-> x==0 end)
		Enum.at(list, Integer.mod(index+start, length))
	end

end