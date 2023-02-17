defmodule Day15 do

	def read(file \\ nil) do
		{_, content} = case file do
			:test -> File.read("lib/AdventOfCode/Day15Test.txt")
			_ -> File.read("lib/AdventOfCode/Day15.txt")
		end
		list = String.split(content, "\r\n", trim: true) |> parse()

		case file do
			:test -> transform(list) |> all_ranges(10) |> final()
			_ -> transform(list) |> all_ranges(2000000) |> final()
		end - 1
	end

	def parse(list) do
		parse_row = fn(head) -> Regex.scan(~r/-?\d+/, head) |> List.flatten() |> Enum.map(fn(x)->String.to_integer(x) end) end
		Enum.map(list, fn(x)-> parse_row.(x) end)
	end

	def transform(list) do
		transform_row = fn([sX, sY, bX, bY])-> d=abs(bX-sX)+abs(bY-sY); {sX, sY, d} end
		Enum.map(list, fn(x)-> transform_row.(x) end)
	end

	def all_ranges(list, num) do
		Enum.map(list, fn(x)-> range(x, num) end)
		|> Enum.filter(fn(x)-> x != nil end)
	end

	def range({sX, sY, d}, y) when abs(y-sY) <= d do
		n = d - abs(y-sY)
		case n do
			0 -> sX..sX
			_ -> (sX-n)..(sX+n)
		end
	end

	def range(_, _) do nil end

	def union(a..b, x..y) do
		if Range.disjoint?(a..b, x..y) do
			nil
		else
			min(a,x)..max(b,y)
		end
	end

	def combine([], result) do result end
	def combine([only], result) do [only]++result end
	def combine([first, second|rest], result) do
		case union(first, second) do
			nil -> combine(rest, [first, second] ++ result)
			set -> combine(rest, [set]++result)
		end
	end

	def final(list) do
		res = combine(list, [])
		if res == list do
			IO.inspect(res)
			Enum.concat(res) |> MapSet.new() |> MapSet.size()
		else
			final(res)
		end
	end

end