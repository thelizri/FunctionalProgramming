defmodule Day3 do
	#First half = Second half
	#a-z = 1-26, A-Z = 27-52

	def read() do
		{:ok, input} = File.read("lib/Day3.txt")
		content = String.split(input, "\r\n")
		list(content, 0)
	end

	def list([head], score) do
		length = String.length(head)
		length = Integer.floor_div(length, 2)
		{first, last} = String.split_at(head, length)
		IO.write("#{first} \n")
	end

	def list([head|tail], score) do
		length = String.length(head)
		length = Integer.floor_div(length, 2)
		{first, last} = String.split_at(head, length)
		IO.write("#{first} \n")
		list(tail, 0)
	end

end