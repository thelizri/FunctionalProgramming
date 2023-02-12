defmodule Day13 do
	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day13.txt")
		String.split(content, "\r\n\r\n") |> checkBlock()
	end

	def checkBlock([block|rest]) do
		[str1, str2] = String.split(block, "\r\n")
		{list1, _} = Code.eval_string(str1)
		{list2, _} = Code.eval_string(str2)
	end
end