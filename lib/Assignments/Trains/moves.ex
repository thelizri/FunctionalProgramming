defmodule Moves do

	# single/2 move state
	# single({:one,1},{[:a,:b],[],[]})
	def single({_, 0}, state) do state end
	
	def single({:one, n}, {[], one, two}) when n < 0 do
		{Train.take(one, -n), Train.drop(one, -n), two}
	end
	def single({:one, n}, {main, one, two}) when n < 0 do
		{Train.append(main, Train.take(one, -n)), Train.drop(one, -n), two}
	end

	def single({:two, n}, {[], one, two}) when n < 0 do
		{Train.take(two, -n), one, Train.drop(two, -n)}
	end
	def single({:two, n}, {main, one, two}) when n < 0 do
		{Train.append(main, Train.take(two, -n)), one, Train.drop(two, -n)}
	end

	def single({:one, n}, {main, [], two}) when n > 0 do
		{k, remain, take} = Train.main(main, n)
		{remain, take, two}
	end
	def single({:one, n}, {main, one, two}) when n > 0 do
		{k, remain, take} = Train.main(main, n)
		{remain, Train.append(take, one), two}
	end

	def single({:two, n}, {main, one, []}) when n > 0 do
		{k, remain, take} = Train.main(main, n)
		{remain, one, take}
	end
	def single({:two, n}, {main, one, two}) when n > 0 do
		{k, remain, take} = Train.main(main, n)
		{remain, one, Train.append(take, two)}
	end

	# sequence
	def sequence(moves, state) do
		sequence(moves, state, [state])
	end

	def sequence([], _, result) do result end
	def sequence([move|rest], state, result) do
		state = single(move, state)
		result = Train.append(result, state)
		sequence(rest, state, result)
	end

end