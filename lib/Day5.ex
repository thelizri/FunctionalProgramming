defmodule Day5 do

	def move(from, to, amount) do
		{cargo, from} = Enum.split(from, amount)
		cargo = Enum.reverse(cargo)
		to = cargo ++ to
		{from, to}
	end

	def read() do
		{status, content} = File.read("lib/Day5.txt")
		rows = String.split(content, "\r\n")
		for row <- rows do
			evaluate_row(row)
		end
	end

	def evaluate_row(row) do
		[_, amount, _, from, _, to] = String.split(row, " ")
		amount = String.to_integer(amount)
		from = String.to_integer(from)
		to = String.to_integer(to)
		{from, to, amount}
	end

end