defmodule Train do

	# Returns the train containing the first n wagons of the train
	def take([], _) do [] end
	def take([wagon|rest], n) when n > 0 do
		[wagon|take(rest, n-1)]
	end
	def take(_, _) do [] end

	# Returns the train train without its first n wagon
	def drop([], _) do [] end
	def drop([wagon|rest], n) when n > 0 do
		drop(rest, n-1)
	end
	def drop(train, _) do train end

	# Returns the train that is the combinations of the two trains
	# Appends right argument, to the end of left argument
	def append([], [train]) do [train] end
	def append([], wagon) do [wagon] end
	def append([wagon|rest], train) do
		[wagon|append(rest, train)]
	end

	# Checks if the wagon is contained in the train
	def member([], wagon) do false end
	def member([head|rest], wagon) do
		cond do
			head == wagon -> true
			true -> member(rest, wagon)
		end
	end

	# Returns the first position of wagon (1 indexed). Returns -1 if it doesn't exist.
	def position(train, wagon, index \\ 1)
	def position([], _, _) do -1 end
	def position([head|rest], wagon, index) do
		cond do
			head == wagon -> index
			true -> position(rest, wagon, index+1)
		end
	end

	# Return a tuple with two trains, all the wagons before y and all wagons after y.
	def split([wagon|rest], wagon) do
		{[], rest}
	end
	def split([head|rest], wagon) do
		{left, right} = split(rest, wagon)
		{[head|left], right}
	end

	# Return a tuple with {k, remain, take}
	def main([], n) do {n, [], []} end
	def main([head|rest], n) do
		case main(rest, n) do
			{0, remain, take} -> {0, [head|remain], take}
			{n, remain, take} -> {n-1, remain, [head|take]}
		end
	end
end