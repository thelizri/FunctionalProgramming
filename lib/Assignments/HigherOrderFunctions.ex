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

end