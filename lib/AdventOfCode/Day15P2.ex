defmodule Day15P2 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day15Test.txt")
		list = String.split(content, "\r\n", trim: true) |> parse()
		|> transform()
		findSpot(list) |> IO.inspect
		|> calcScore
	end

	def parse(list) do
		parse_row = fn(head) -> Regex.scan(~r/-?\d+/, head) |> List.flatten() |> Enum.map(fn(x)->String.to_integer(x) end) end
		Enum.map(list, fn(x)-> parse_row.(x) end)
	end

	def transform(list) do
		transform_row = fn([sX, sY, bX, bY])-> d=abs(bX-sX)+abs(bY-sY); {sX, sY, d} end
		Enum.map(list, fn(x)-> transform_row.(x) end)
	end

	def isInRange?({x, y}, {a,b,d}) do
		dist = abs(a-x) + abs(b-y)
		dist <= d
	end

	def checkIfInRangeOfAll?(pos, []) do false end
	def checkIfInRangeOfAll?(pos, [head|rest]) do
		case isInRange?(pos, head) do
			true -> true
			false -> checkIfInRangeOfAll?(pos, rest)
		end
	end

	#def findSpot(list) do
	#	for i <- 0..20, j <- 0..20 do
	#		bool=checkIfInRangeOfAll?({i,j},list)
	#		case bool do
	#			true -> nil
	#			false -> {i, j}
	#		end
	#	end |> Enum.filter(fn(x) -> x != nil end) |> Enum.at(0)
	#end

	def findSpot(list, {i,j} \\ {0, 0}) do
		case checkIfInRangeOfAll?({i, j}, list) do
			false -> {i, j}
			true -> 
				case counter = increase_counter(i, j) do
					:end -> :noresult
					_ -> findSpot(list, counter)
				end
		end
	end

	def increase_counter(i, j) when i <= 20 and j <= 20 do
		case {i, j} do
			{20, 20} -> :end
			{_, 20} -> {i+1, 0}
			{_, _} -> {i, j+1}
		end 
	end
	def increase_counter(_, _) do :end end

	def calcScore({x, y}) do
		4000000*x + y
	end

	def traverse_outside_range({x,y,d}) do

	end

end