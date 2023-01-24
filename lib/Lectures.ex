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

	def union([], y) do y end

	def union([h|t], y) do
		z = union(t,y)
		[h|z]
	end

end