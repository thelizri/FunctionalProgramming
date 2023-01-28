defmodule Day16 do

	def read() do
		{_, content} = File.read("lib/AdventOfCode/Day16.txt")
		String.split(content, "\r\n") |>
		evaluate_row([])
	end

	def evaluate_row([], results) do
		Enum.reverse(results)
	end

	def evaluate_row([head|rest], results) do
		nodes = Regex.scan(~r/\s*[A-Z]{2}\s*/, head)
		|> List.flatten
		[node|links] = for node <- nodes do
			String.trim(node)
		end
		number = Regex.scan(~r/\d+/, head) |> List.flatten |> Enum.at(0) |> String.to_integer
		evaluate_row(rest, [{node, number, links}|results])
	end

end