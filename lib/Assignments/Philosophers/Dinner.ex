defmodule Dinner do

	def start(seed) do spawn(fn -> init(seed) end) end
	def init(seed) do
		:rand.seed(:exsss, {seed, seed, seed})
		c1 = Chopstick.start()
		c2 = Chopstick.start()
		c3 = Chopstick.start()
		c4 = Chopstick.start()
		c5 = Chopstick.start()
		ctrl = self()
		Philosopher.start(5, c1, c2, "Arendt", ctrl, :rand.uniform(9999999))
		Philosopher.start(5, c2, c3, "Hypatia", ctrl, :rand.uniform(9999999))
		Philosopher.start(5, c3, c4, "Simone", ctrl, :rand.uniform(9999999))
		Philosopher.start(5, c4, c5, "Elisabeth", ctrl, :rand.uniform(9999999))
		Philosopher.start(5, c5, c1, "Ayn", ctrl, :rand.uniform(9999999))
		wait(5, [c1, c2, c3, c4, c5])
	end

	def wait(0, chopsticks) do
		Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
		IO.puts("The Philosophers have finished dining")
	end
	def wait(n, chopsticks) do
		receive do
			:done -> wait(n - 1, chopsticks)
			:abort -> IO.puts("Aborting"); Process.exit(self(), :kill)
		after
			10_000 -> IO.puts("We seem to have entered a deadlock. Everyone dies."); Process.exit(self(), :kill)
		end
	end
end