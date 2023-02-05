defmodule Floyd do

	def test() do
		for k <- 1..3, i <- 1..3, j <- 1..3 do
			{k, i, j}
		end
	end

	def test2() do
		loopk(3, 2, 2, nil, nil)
	end

	def loopk(k, i, j, args, result) do
		result = loopi(k, i, j, args, result)
		cond do k > 1 -> loopk(k-1, i, j, args, result); true -> result; end
	end

	def loopi(k, i, j, args, result) do
		result = loopj(k, i, j, args, result)
		cond do i > 1 -> loopi(k, i-1, j, args, result); true -> result; end
	end

	def loopj(k, i, j, args, result) do
		:io.write({k,i,j})
		IO.puts("  <- Value")
		cond do j > 1 -> loopj(k, i, j-1, args, result); true -> result; end
	end
end