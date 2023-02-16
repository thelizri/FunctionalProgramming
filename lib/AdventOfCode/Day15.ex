defmodule Day15 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day15.txt")
		list = String.split(content, "\r\n", trim: true) |> parse()
		list = transform(list) #|> all_ranges() |> final()
		tt = for num <- 0..20 do
			{num, all_ranges(list, num) |> final()}
		end
		for t <- tt do
			{row, list} = t
			case rs = isMember(list, 0..20) do
				true -> nil
				_ -> {row, rs}
			end
		end |> Enum.filter(fn(x) -> x != nil end)
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
		cond do
			b + 1 == x -> a..y
			y + 1 == a -> x..b  
			Range.disjoint?(a..b, x..y) -> nil
			true -> min(a,x)..max(b,y)
		end
	end

	def combine([], result) do Enum.shuffle(result) end
	def combine([only], result) do Enum.shuffle([only]++result) end
	def combine([first, second|rest], result) do
		case union(first, second) do
			nil -> combine(rest, [first, second] ++ result)
			set -> combine(rest, [set]++result)
		end
	end

	def final(list, num \\ 0) do
		res = combine(list, [])
		if res == list or num > 10 do
			res
		else
			final(res, num+1)
		end
	end

	def isMember(list, a..b) do
		result = Enum.map(a..b, fn(num)->{num, isMember(list, num)} end)
		|> Enum.filter(fn({num, bool})-> !bool end)
		case result do
			[] -> true
			_ -> result
		end
	end

	def isMember(list, num) do
		Enum.reduce(list, false, fn(x, acc) -> 
			cond do 
				Enum.member?(x, num) -> true
				true -> acc
			end
				end )
	end

	# 0 <= x,y <= 20

end