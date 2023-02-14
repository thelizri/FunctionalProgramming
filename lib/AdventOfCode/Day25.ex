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
end