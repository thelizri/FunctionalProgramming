defmodule Day7 do

	def new() do
		{"/", :unknown, []}
	end

	def add({a, b, list}, new) do
		{a, b, list ++ new}
	end

	def down([{target, size, list}|rest], target) do
		{target, size, list}
	end

	def down([head|rest], target) do
		down(rest, target)
	end

end