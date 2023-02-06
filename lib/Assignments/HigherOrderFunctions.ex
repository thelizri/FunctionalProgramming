defmodule HigherOrder do

	########################################################################################
	# Recursively Transforming Lists

	def double(numbers, result \\ [])
	def double([], result) do result end
	def double([number|rest], result) do
		result = result ++ [number*2]; double(rest, result)
	end

	def five(numbers, result \\ [])
	def five([], result) do result end
	def five([number|rest], result) do
		result = result ++ [number+5]; five(rest, result)
	end

	def animal(animals, result \\ [])
	def animal([], result) do result end
	def animal([animal|rest], result) do
		case animal do
			:dog -> animal(rest, result++[:fido])
			_ -> animal(rest, result++[animal])
		end
	end

	def double_five_animal(list, args) do
		case args do
			:double -> double(list)
			:five -> five(list)
			:animal -> animal(list)
		end
	end

	########################################################################################
	# Map
	def apply_to_all([], function) do [] end
	def apply_to_all([head|rest], function) do
		[function.(head)|apply_to_all(rest, function)]
	end

	########################################################################################
	# Reduce
	def sum([sum]) do sum end
	def sum([head|rest]) do head + sum(rest) end

	def fold_right([], acc, _) do acc end
	def fold_right([head|rest], acc, function) do
		function.(head, fold_right(rest, acc, function))
	end

	def fold_left([], acc, _) do acc end
	def fold_left([head|rest], acc, function) do
		fold_left(rest, function.(head, acc), function)
	end

	########################################################################################
	# Filter


	########################################################################################
	# The Important Functions
	# Enum.map(list, function)                           -----> For executing a function on all elements
	# Enum.reduce(list, accumulator, function)           -----> For accumulating a result based on the function and list. For example the sum of the list.
	# Enum.filter(list, function)						 -----> For filtering out items in the list that meet a certain condition


	# Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
	# [2]

	# Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)
	# 6

	# Enum.map([1, 2, 3], fn x -> x * 2 end)
	# [2, 4, 6]
end