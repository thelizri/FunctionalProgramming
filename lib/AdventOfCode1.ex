defmodule AOC do

	def read() do
		{:ok, input} = File.read("lib/input2.txt")
		content = String.split(input, "\r\n\r\n")
		find_elf(0, 0, 0, content)
	end

	def find_elf(curpos, maxpos, max, [head]) do
		current_position = curpos+1
		integers_in_form_of_strings = String.split(head, "\r\n")
		value = calc(integers_in_form_of_strings, 0)
		IO.write("Value of position #{current_position} is #{value} \n")
		if value > max do
			current_position
		else
			maxpos
		end
	end

	def find_elf(curpos, maxpos, max, [head|rest]) do
		current_position = curpos+1
		integers_in_form_of_strings = String.split(head, "\r\n")
		value = calc(integers_in_form_of_strings, 0)
		IO.write("Value of position #{current_position} is #{value} \n")

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

end