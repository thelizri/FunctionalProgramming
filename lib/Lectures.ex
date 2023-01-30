defmodule Lecture2 do 


	def print([1, 2 | tail]) do
		:io.write(tail)
	end

	def foo(x, y) do
		try do
			{:ok, [x,y]}
		rescue
			error ->
				{:error, error}
		end
	end

	def append(list1, list2) do
		list1 ++ list2 #O(n) time complexity. Appends recursively
	end

	#Tail recursion
	def tailr([], y) do y end

	def tailr([h|t], y) do
		z = [h|y]
		tailr(t,z) #End with recursive call. Don't need stack since we don't have anything to return and execute.
	end

	#Uses up stack
	def union([], y) do y end

	def union([h|t], y) do
		z = union(t,y)
		[h|z]
	end

end

defmodule Lecture4 do

	#Accumulating parameter

	def reverse(x) do reverse(x, []) end
	def reverse([], reversed) do reversed end
	def reverse([head|tail], reversed) do reverse(tail, [head|reversed]) end

	#All recursive functions can be turned into tail recursive functions
	#Using tail recursion can increase the complexity, which needs to be kept in mind

	def flat([]) do [] end
	def flat(x) do flat(x, []) end

	def flat([], plank) do plank end
	def flat([head|tail], plank) do flat(tail, plank ++ head) end

	#Get n:th element of a list: Enum.at(list, n)
	def getNelem(list, n) do Enum.at(list, n) end

end


defmodule Evaluation do

	#x+5*2, find a better way to express it

	#atom ::= :a | :b | :c | ...
	#variable ::= x | y | z | ...
	#literal ::= <atom>
	#expression ::= <literal> | <variable> | '{' expression ',' expression '}'
	#pattern ::= <literal> | <variable> | '_' | '{' <pattern> ',' <pattern> '}'


end