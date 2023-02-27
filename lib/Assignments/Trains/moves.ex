defmodule Moves do

	# single/2 move state
	# single({:one,1},{[:a,:b],[],[]})
	def single({_, 0}, state) do state end
	def single({:one, n}, {main, one, two}) when n < 0 do
		{one, main, two} = single({:one, -n}, {one, main, two})
		{main, one, two}
	end
	def single({:two, n}, {main, one, two}) when n < 0 do
		{two, one, main} = single({:two, -n}, {two, one, main})
		{main, one, two}
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

end