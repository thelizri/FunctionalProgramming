defmodule Dinner do

	def test(sleep) do
		Enum.each(101..400, fn(n)-> start(n, self(), sleep) end)
		num = sum(0)
		iterations = 300
		IO.puts("Successful iterations: #{num}. Total iterations: #{iterations}. Ratio: #{num/iterations}")
	end

	def sum(n) do
		receive do
			:ok -> sum(n+1)
			:deadlock -> sum(n)
		after
			60_000 -> n
		end
	end

	def start(seed, pid, sleep) do spawn(fn -> init(seed, pid, sleep) end) end
	def init(seed, pid, sleep) do
		:rand.seed(:exsss, {seed, seed, seed})
		c1 = Chopstick.start()
		c2 = Chopstick.start()
		c3 = Chopstick.start()
		c4 = Chopstick.start()
		c5 = Chopstick.start()
		ctrl = self()
		Philosopher.start(5, c1, c2, "Arendt", ctrl, :rand.uniform(9999999), sleep)
		Philosopher.start(5, c2, c3, "Hypatia", ctrl, :rand.uniform(9999999), sleep)
		Philosopher.start(5, c3, c4, "Simone", ctrl, :rand.uniform(9999999), sleep)
		Philosopher.start(5, c4, c5, "Elisabeth", ctrl, :rand.uniform(9999999), sleep)
		Philosopher.start(5, c5, c1, "Ayn", ctrl, :rand.uniform(9999999), sleep)
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
			30_000 -> IO.puts("We seem to have entered a deadlock. Everyone dies."); Process.exit(self(), :kill)
			send(pid, :deadlock)
		end
	end
end