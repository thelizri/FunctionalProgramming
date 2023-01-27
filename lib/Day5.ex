defmodule Day5 do

	def move(from, to, amount) do
		{cargo, from} = Enum.split(from, amount)
		cargo = Enum.reverse(cargo)
		to = cargo ++ to
		{from, to}
	end

	def read() do
		{_, content} = File.read("lib/Day5.txt")
		rows = String.split(content, "\r\n")
		commands = for row <- rows do
			evaluate_row(row)
		end
		execute_program(commands, create_data())
	end

	def evaluate_row(row) do
		[_, amount, _, from, _, to] = String.split(row, " ")
		amount = String.to_integer(amount)
		from = String.to_integer(from)
		to = String.to_integer(to)
		{from, to, amount}
	end

	def execute_program([], data) do
		present_result(data)
	end

	def execute_program([{from, to, amount}|tail], data) do
		fromData = elem(data, from-1)
		toData = elem(data, to-1)
		{fromData, toData} = move(fromData, toData, amount)
		data = put_elem(data, from-1, fromData)
		data = put_elem(data, to-1, toData)
		execute_program(tail, data)
	end

	def create_data() do
		first = ["R", "W", "F", "H", "T", "S"]
		second = ["W", "Q", "D", "G", "S"]
		third = ["W", "T", "B"]
		fourth = ["J", "Z", "Q", "N", "T", "W", "R", "D"]
		fifth = ["Z", "T", "V", "L", "G", "H", "B", "F"]
		sixth = ["G", "S", "B", "V", "C", "T", "P", "L"]
		seventh = ["P", "G", "W", "T", "R", "B", "Z"]
		eight = ["R", "J", "C", "T", "M", "G", "N"]
		ninth = ["W", "B", "G", "L"]

		{first, second, third, fourth, fifth, sixth, seventh, eight, ninth}
	end

	def present_result(data) do
		size = tuple_size(data)
		size = size-1
		for colNum <- 0..size do
			result = Enum.at(elem(data, colNum), 0)
			IO.write("#{result}")
		end
	end

end