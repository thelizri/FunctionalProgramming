defmodule AOC do

	def read() do
		{:ok, input} = File.read("lib/input2.txt")
		content = String.split(input, "\n\n")
		find_elf(0, 0, content)
	end

	def find_elf(pos, max, [head]) do
		current_position = pos+1
		integers_in_form_of_strings = String.split(head, "\n")
		value = calc(integers_in_form_of_strings, 0)

		if value > max do
			current_position
		else
			pos
		end
	end

	def find_elf(pos, max, [head|rest]) do
		current_position = pos+1
		integers_in_form_of_strings = String.split(head, "\n")
		value = calc(integers_in_form_of_strings, 0)

		if value > max do
			find_elf(current_position, value, rest)
		else
			find_elf(pos, max, rest)
		end
	end

	def calc([head], sum) do
		x = String.to_integer(head)
		sum+x
	end

	def calc([head|rest], sum) do
		x = String.to_integer(head)
		calc(rest, sum+x)
	end

end