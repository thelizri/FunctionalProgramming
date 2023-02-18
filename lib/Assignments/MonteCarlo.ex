defmodule MonteCarlo do

	# Area = r²
	# Area of arch = pi*r²/4
	# Probability of hitting inside arch = pi/4
	# pi = 4*num of darts in arch/num of darts thrown

	def run(num) do
		run(num, num, 10000, 0)
	end

	def run(num, loop, r, result) when loop > 0 do
		case inArch?(getRand(r), r) do
			true -> run(num, loop-1, r, result+1)
			false -> run(num, loop-1, r, result)
		end
	end

	def run(num, loop, _, result) do
		4*result/num
	end

	def inArch?({x,y}, r) do
		x*x + y*y <= r*r
	end

	def getRand(radius) do
		x = Enum.random(0..radius)
		y = Enum.random(0..radius)
		{x, y}
	end

end