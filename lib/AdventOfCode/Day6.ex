defmodule Day6 do

	def read() do
		{_status, content} = File.read("lib/AdventOfCode/Day6.txt")
		list = String.to_charlist(content)
		last14 = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
		processing(list, 1, last14)
	end

	def processing([], _, _) do
		nil
	end

	def processing([head|tail], score, last14) do
		last14 = push_and_pop(last14, head)
		map = MapSet.new(last14)
		if MapSet.size(map) > 13 do
			score
		else
			processing(tail, score+1, last14)
		end
	end

	def push(list, add) do
		[add|list]
	end

	def pop([_last]) do
		[]
	end

	def pop([head|tail]) do
		[head|pop(tail)]
	end

	def push_and_pop(list, add) do
		push(list, add) |> pop()
	end

end