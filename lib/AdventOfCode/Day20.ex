defmodule Day20 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day20.txt")
		{list, _} = String.split(content, "\r\n", trim: true)
		|> Enum.map(fn(x)-> String.to_integer(x) end)
		|> Enum.reduce({[],0},fn(x, {list, index})-> {list ++ [{x, index}], index+1} end)
		list
	end

	def sum(list) do
		s1 = getAt(1000, list)
		s2 = getAt(2000, list)
		s3 = getAt(3000, list)
		s1+s2+s3
	end

	def getAt(num, list) do
		length = length(list)
		index = rem(num, length)
		start = Enum.find_index(list, fn(x)-> x==0 end)
		Enum.at(list, rem(index+start, length))
	end

end