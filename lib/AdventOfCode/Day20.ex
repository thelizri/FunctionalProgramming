defmodule Day20 do

	def getAt(num, list) do
		length = length(list)
		index = rem(num, length)
		start = Enum.find_index(list, fn(x)-> x==0 end)
		Enum.at(list, rem(index+start, length))
	end

end