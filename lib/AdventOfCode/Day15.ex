defmodule Day15 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day15.txt")
		String.split(content, "\r\n", trim: true) |> parse()
	end

	def parse(list) do
		parse_row = fn(head) -> Regex.scan(~r/-*\d+/, head) |> List.flatten() |> Enum.map(fn(x)->String.to_integer(x) end) end
		Enum.map(list, fn(x)-> parse_row.(x) end)
	end
end