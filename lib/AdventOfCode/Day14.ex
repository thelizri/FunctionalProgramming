defmodule Day14 do
	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day14.txt")
		String.split(content, "\r\n", trim: true)
		|> Enum.map(fn(row)-> parse_row(row) end)
		|> Enum.reduce(MapSet.new(), fn(x, acc)-> transform_row(x, acc) end)
		|> main()
	end

	def parse_row(row) do
		String.split(row, "->", trim: true)
		|> Enum.map(fn(string)-> [x, y] = String.split(string, ",", trim: true); 
			{String.trim(x)|>String.to_integer(), String.trim(y)|>String.to_integer()} end)
	end

	def transform_row([{x, y}, {a, b}|rest], map) do
		res = cond do
			x == a -> Enum.map(y..b, fn(n)->{x, n} end)
			y == b -> Enum.map(x..a, fn(n)->{n, y} end)
		end
		|> Enum.reduce(map, fn(x, acc)-> MapSet.put(acc, x) end)
		transform_row([{a,b}|rest], res)
	end
	def transform_row(_, map) do map end

	#We have translated the input to a mapset containing the {x, y} coordinates that are occupied
	def main(mapset) do
		MapSet.to_list(mapset)
	end

end