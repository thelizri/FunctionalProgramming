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

# Rules
# 1. If both values are integers, the lower integer should come first.
# 2. If both values are lists, compare the first value of each list, then the second value, and so on.
# 3. If exactly one value is an integer, convert the integer to a list which contains that integer as its only value, then retry the comparison.