defmodule Hanoi do
	# Pegs are defined as :a, :b, :c
	# Move is represented by a tuple. {:move, from, to}

	def find_move(1, from, aux, to) do
		[{:move, from, to}]
	end

	def find_move(n, from, aux, to) do
		find_move(n-1, from, to, aux) ++ [{:move, from, to}] ++ find_move(n-1, aux, from, to)
	end

end