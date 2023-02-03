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

	

end