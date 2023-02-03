defmodule Hanoi do
	# Pegs are defined as :a, :b, :c
	# Move is represented by a tuple. {:move, from, to}

	def find_move(0, _, _, _) do [] end
	def find_move(n, from, aux, to) do
		find_move(n-1, from, to, aux) ++ [{:move, from, to}] ++ find_move(n-1, aux, from, to)
	end

	# Algorithm for moving N from -> to, with aux peg
	# Function definition: shift(number, position, aux, destination)
	# shift(n, from, aux, to)
	# 	1. shift(n-1, from, to, aux)
	#   2. move last piece from to
	#   3. shift(n-1, aux, from, to)

end