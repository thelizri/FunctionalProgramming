defmodule HigherOrder do

	def double(numbers) do
		for num <- numbers do
			2*num
		end
	end

	def five(numbers) do
		for num <- numbers do
			num + 5
		end
	end

	def animal(animals) do
		for animal <- animals do
			case animal do
				:dog -> :fido
				_ -> animal
			end
		end
	end


	########################################################################################
	# Without using list comprehensions

	def double2(numbers) do
		Enum.reverse(double2(numbers, []))
	end

	def double2([], accumulator) do accumulator end

	def double2([head|rest], accumulator) do
		double2(rest, [2*head|accumulator])
	end

	def five2(numbers) do
		Enum.reverse(five2(numbers, []))
	end

	def five2([], accumulator) do accumulator end

	def five2([head|rest], accumulator) do
		five2(rest, [5+head|accumulator])
	end

	########################################################################################
	# With higher order functions

	# This is the same as the Enum.map(list, function)
	def apply_to_all(list, function) do
		for item <- list do function.(item) end
	end

	def fold_right([], base, function) do base end

	def fold_right(list, base, function) do
		for item <- list do function.(item, base) end
	end


	########################################################################################
	# The important functions
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