defmodule Dinner do
	###########################################################################################################
	# Benchmark



	###########################################################################################################
	# Test

	@mytimeout 60_000
	@checkdead 4_000

	def test(sleep) do
		list = Enum.map(1..1000, fn(n)-> start(self(), sleep) end)
		num = sum(0, list)
		iterations = 1000
		IO.puts("Successful iterations: #{num}. Total iterations: #{iterations}. Ratio: #{num/iterations}")
	end

	def sum(n, list) do
		receive do
			:ok -> sum(n+1, list)
			:deadlock -> sum(n, list)
		after
			@checkdead -> 
				case all_dead(list) do
					true -> n
					false -> sum(n, list)
				end
		end
	end

	def all_dead([]) do true end
	def all_dead([head|rest]) do
		case Process.alive?(head) do
			true -> false
			false -> all_dead(rest)
		end
	end

	###########################################################################################################
	# Code 

	def start(pid, sleep) do spawn(fn -> init(pid, sleep) end) end
	def init(pid, sleep) do
		c1 = Chopstick.start()
		c2 = Chopstick.start()
		c3 = Chopstick.start()
		c4 = Chopstick.start()
		c5 = Chopstick.start()
		ctrl = self()
		Philosopher.async_start(5, c1, c2, "Arendt", ctrl, sleep, sleep)
		Philosopher.async_start(5, c2, c3, "Hypatia", ctrl, sleep, sleep)
		Philosopher.async_start(5, c3, c4, "Simone", ctrl, sleep, sleep)
		Philosopher.async_start(5, c4, c5, "Elisabeth", ctrl, sleep, sleep)
		Philosopher.async_start(5, c5, c1, "Ayn", ctrl, sleep, sleep)
		wait(5, [c1, c2, c3, c4, c5], pid)
	end

	def wait(0, chopsticks, pid) do
		Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
		IO.puts("The Philosophers have finished dining")
		send(pid, :ok)
	end
	def wait(n, chopsticks, pid) do
		receive do
			:done -> wait(n - 1, chopsticks, pid)
			:abort -> IO.puts("Aborting"); Process.exit(self(), :kill)
		after
			@mytimeout -> IO.puts("We seem to have entered a deadlock. Everyone dies."); Process.exit(self(), :kill)
			send(pid, :deadlock)
		end
	end
end