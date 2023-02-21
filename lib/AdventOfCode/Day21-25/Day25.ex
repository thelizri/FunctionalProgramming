defmodule Day25 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day25.txt")
		list = String.split(content, "\r\n", trim: true)
		getSum(list) |> IO.inspect |> toSNAFU()
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
			num < 5 -> Integer.to_string(num) <> result
			true -> base10To5(num, result)
		end
	end

	# Decimal          SNAFU
	#        1              1
	#        2              2
	#        3             1=
	#        4             1-
	#        5             10
	#        6             11
	#        7             12
	#        8             2=
	#        9             2-
	def toSNAFU(num) do
		list = base10To5(num) |> String.reverse() |>String.split("", trim: true)
		toSNAFU(list, 0, "")
	end

	def toSNAFU([], carry, result) do
		case carry do
			0 -> result
			1 -> "1" <> result
			2 -> "2" <> result
		end
	end

	def toSNAFU([num|rest], carry, result) do
		num = String.to_integer(num)+carry
		case num do
			0 -> toSNAFU(rest, 0, "0" <> result)
			1 -> toSNAFU(rest, 0, "1" <> result)
			2 -> toSNAFU(rest, 0, "2" <> result)
			3 -> toSNAFU(rest, 1, "=" <> result)
			4 -> toSNAFU(rest, 1, "-" <> result)
			5 -> toSNAFU(rest, 1, "0" <> result)
			6 -> toSNAFU(rest, 1, "1" <> result)
		end
	end

end