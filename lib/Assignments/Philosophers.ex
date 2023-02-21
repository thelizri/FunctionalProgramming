#spawn                   pid = spawn(fn-> :gurka end)
#send/2                  send(pid, message)
#receive				 receive do pattern -> :gurka; pattern2 -> :gurka2; end
#receive will wait if the mailbox is empty or there is no matching pattern
#I can have multiple recieve in different functions. When a message is sent, it's put in a bucket that belongs to my process.
#


defmodule Storage do

	def run() do
		spawn(fn -> loop(%{}) end)
	end

	defp loop(map) do
	    receive do
	    	{:get, key, caller} ->
	        	send(caller, {key, Map.get(map, key)}); loop(map)
	    	{:put, key, value} -> 
	    		loop(Map.put(map, key, value))
	    end
  	end

end

defmodule ConPro do

	def main do
		Storage.run()
	end

	def store(pid, key, value) do
		send(pid, {:put, key, value})
	end

	def get(pid, key) do
		send(pid, {:get, key, self()})
		receive do
			{key, value} -> value
		end
	end

end

defmodule Chopstick do

	def start do
		stick = spawn_link(fn -> available() end)
	end

	def available() do
		receive do
			{:request, from} -> send(from, :ok); gone()
			:quit -> :ok
		end
	end

	def gone() do
		receive do
			:return -> available()
			:quit -> :ok
		end
	end

	#########################################################################################
	# Interface
	def request(stick, from) do
		send(stick, {:request, from})
	end

	def return(stick) do
		send(stick, :return)
	end

	def quit(stick) do
		send(stick, :quit)
	end
end

defmodule Philosopher do

	def start(hunger, left, right, name, ctrl) do
		spawn_link(fn -> 
			Enum.each(1..hunger, fn(n)-> sleep(1000); IO.puts("#{name} wants to eat."); eat(left, right, name) end)
			send(ctrl, :done)
			IO.puts("\n\n#{name} has died from food poisoning.\n")
			end)#
	end

	def sleep(0) do :ok end
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end

	def eat(left, right, name) do
		Chopstick.request(left, self())
		receive do
			:ok -> IO.puts("#{name} received left chopstick!")
		end
		Chopstick.request(right, self())
		receive do
			:ok -> IO.puts("#{name} received right chopstick!")
		end
		IO.puts("#{name} eats a bite")
		Chopstick.return(left)
		Chopstick.return(right)
	end
end

defmodule Dinner do

	def start() do spawn(fn -> init() end) end
	def init() do
		c1 = Chopstick.start()
		c2 = Chopstick.start()
		c3 = Chopstick.start()
		c4 = Chopstick.start()
		c5 = Chopstick.start()
		ctrl = self()
		Philosopher.start(5, c1, c2, "Arendt", ctrl)
		Philosopher.start(5, c2, c3, "Hypatia", ctrl)
		Philosopher.start(5, c3, c4, "Simone", ctrl)
		Philosopher.start(5, c4, c5, "Elisabeth", ctrl)
		Philosopher.start(5, c5, c1, "Ayn", ctrl)
		wait(5, [c1, c2, c3, c4, c5])
	end

	def wait(0, chopsticks) do
		Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
		IO.puts("The Philosophers have finished dining")
	end
	def wait(n, chopsticks) do
		receive do
			:done -> wait(n - 1, chopsticks)
			:abort -> Process.exit(self(), :kill)
		after
			10_000 -> IO.puts("We seem to have entered a deadlock. Everyone dies."); Process.exit(self(), :kill)
		end
	end
end