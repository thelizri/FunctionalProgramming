defmodule Day1 do

	def read() do
		{:ok, input} = File.read("lib/Day1.txt")
		content = String.split(input, "\r\n\r\n")
		max = top_3(content, {0,0,0})
		sum(max)
	end

	def find_elf(_curpos, _maxpos, max, [head]) do
		integers_in_form_of_strings = String.split(head, "\r\n")
		value = calc(integers_in_form_of_strings, 0)
		if value > max do
			value
		else
			max
		end
	end

	def find_elf(curpos, maxpos, max, [head|rest]) do
		current_position = curpos+1
		integers_in_form_of_strings = String.split(head, "\r\n")
		value = calc(integers_in_form_of_strings, 0)
		if value > max do
			find_elf(current_position, current_position, value, rest)
		else
			find_elf(current_position, maxpos, max, rest)
		end
	end

	def calc([head], sum) do
		case head do
			"" -> sum
			_ -> x = String.to_integer(head); sum+x
		end
	end

	def calc([head|rest], sum) do
		case head do
			"" -> sum
			_ -> x = String.to_integer(head); calc(rest, sum+x)
		end
	end

	def top_3([head], max) do
		ints = String.split(head, "\r\n")
		value = calc(ints, 0)
		updateMax(value, max)
	end

	def top_3([head|rest], max) do
		ints = String.split(head, "\r\n")
		value = calc(ints, 0)
		max = updateMax(value, max)
		top_3(rest, max)
	end

	def updateMax(value, {max1, max2, max3}) do
		cond do
			value > max1 -> {value, max1, max2}
			value > max2 -> {max1, value, max2}
			value > max3 -> {max1, max2, value}
			true -> {max1, max2, max3}
		end
	end

	def sum({max1, max2, max3}) do
		max1+max2+max3
	end

end
