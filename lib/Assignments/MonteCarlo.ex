defmodule MonteCarlo do

	# Area = r²
	# Area of arch = pi*r²/4
	# Probability of hitting inside arch = pi/4
	# pi = 4*num of darts in arch/num of darts thrown

  def rounds(loop, r)  do
    rounds(loop, 1000, r)
  end
  
  def rounds(0, n, _) do :ok end
  def rounds(loop, n, r) do
    pi = run(n, r)
    :io.format(" n = ~12w, pi = ~14.10f,  Delta Real Pi = ~14.10f, Delta Archimedes = ~8.4f,  Delta Zu Chongzhi = ~12.8f\n", [n, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    rounds(loop-1, n*2, r)
  end

  #Num = the number of darts we throw
	def run(num, r) do
		run(num, num, r, 0)
	end

	def run(num, loop, r, result) when loop > 0 do
		case inArch?(getRandom(r), r) do
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

	def getRandom(radius) do
		x = Enum.random(0..radius)
		y = Enum.random(0..radius)
		{x, y}
	end

end
