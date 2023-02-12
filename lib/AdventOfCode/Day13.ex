defmodule Day13 do
	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day13.txt")
		String.split(content, "\r\n\r\n") |> checkBlock(1, [])
	end

	def checkBlock([], _, result) do IO.inspect(result); Enum.sum(result) end
	def checkBlock([block|rest], index, result) do
		[str1, str2] = String.split(block, "\r\n")
		{list1, _} = Code.eval_string(str1)
		{list2, _} = Code.eval_string(str2)
		case compareRows(list1, list2) do
			true -> checkBlock(rest, index+1, result ++ [index])
			false -> checkBlock(rest, index+1, result)
		end
	end

	def compareInts(first, second) when is_integer(first) and is_integer(second) do
		first <= second
	end

	def compareRows([], []) do true end
	def compareRows(head, []) do false end
	def compareRows([], head) do true end
	def compareRows([head1|rest1], [head2|rest2]) do
		type = {is_integer(head1), is_integer(head2)}
		result = case type do
			{true, true} -> compareInts(head1, head2)
			{true, false} -> compareRows(head1, [head2])
			{false, true} -> compareRows([head1], head2)
			{false, false} -> compareRows(head1, head2)
		end
		case result do
			false -> false
			true -> compareRows(rest1, rest2)
		end
	end
	#def compareRows([head1|rest1], head2) do
	#	compareRows([head1|rest1], [head2])
	#end
	#def compareRows(head1, [head2|rest2]) do
	#	compareRows([head1], [head2|rest2])
	#end
	def compareRows(head1, head2) do head1 <= head2 end
end

# Rules
# 1. If both values are integers, the lower integer should come first.
# 2. If both values are lists, compare the first value of each list, then the second value, and so on.
# 3. If exactly one value is an integer, convert the integer to a list which contains that integer as its only value, then retry the comparison.