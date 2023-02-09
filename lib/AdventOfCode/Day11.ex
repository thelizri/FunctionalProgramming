defmodule Day11 do


	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day11.txt")
		content = String.split(content, "\r\n\r\n")
		map = Map.new()
		parse_block(content, map)
	end

	def operations(monkey, item) do
		case monkey do
			0 -> item * 19
			1 -> item + 6
			2 -> item * item
			3 -> item + 3
		end |> div(3)
	end


	def parse_block([], map) do map end
	def parse_block([content|rest], map) do
		[row1, row2, row3, row4, row5, row6] = String.split(content, "\r\n")

		#Row 1, monkey 
		[monkey] = getNumbers(row1)
		monkey = String.to_integer(monkey)

		#Row 2, starting items
		list = getNumbers(row2) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :items}, list)

		#Row 4, divisible by number
		[div] = getNumbers(row4) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :div}, div)

		#Row 5, if true, throw to monkey
		[true_monkey] = getNumbers(row5) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :true}, true_monkey)

		#Row 6, if false, throw to monkey
		[false_monkey] = getNumbers(row6) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :true}, false_monkey)

		#Recursion
		parse_block(rest, map)
	end

	def getNumbers(string) do
		Regex.scan(~r/\d+/, string) |> List.flatten
	end

end