defmodule Day25 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day25.txt")
		list = String.split(content, "\r\n", trim: true)
		getSum(list)
	end

	def getSum(list) do
		Enum.reduce(list, 0, fn(x, acc)->acc+calcNum(x) end)
	end

	def calcNum(string) do
		{sum, _} = String.reverse(string) |> String.split("", trim: true)
		|> Enum.reduce({0, 1}, fn(x, {sum, mul})-> {sum + charToNum(x)*mul, mul*5} end)
		sum
	end

	def charToNum(string) do
		case string do
			"=" -> -2
			"-" -> -1
			_ -> String.to_integer(string)
		end
	end

	def base10To5(num, result \\ "") do
		result = Integer.to_string(rem(num, 5)) <> result
		num = div(num, 5)
		cond do
			num < 5 -> Integer.to_string(num) <> result |> String.to_integer
			true -> base10To5(num, result)
		end
	end

end