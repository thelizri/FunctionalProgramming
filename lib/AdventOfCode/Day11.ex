defmodule Day11 do


	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day11.txt")
		[head|rest] = String.split(content, "\r\n\r\n")
		parse_block(head)
	end

	def parse_block(content) do
		[row1, row2, row3, row4, row5, row6] = String.split(content, "\r\n")
		#Row 1, monkey 
		[monkey] = getNumbers(row1)
		monkey = String.to_integer(monkey)
		#Row 2, starting items
		list = getNumbers(row2) |> Enum.map(fn(x) -> String.to_integer(x) end)
		#Row 4, divisible by number
		[div] = getNumbers(row4) |> Enum.map(fn(x) -> String.to_integer(x) end)
		#Row 5, if true, throw to monkey
		[true_monkey] = getNumbers(row5) |> Enum.map(fn(x) -> String.to_integer(x) end)
		#Row 6, if false, throw to monkey
		[false_monkey] = getNumbers(row6) |> Enum.map(fn(x) -> String.to_integer(x) end)
		{monkey, list, div, true_monkey, false_monkey}
	end

	def getNumbers(string) do
		Regex.scan(~r/\d+/, string) |> List.flatten
	end

end