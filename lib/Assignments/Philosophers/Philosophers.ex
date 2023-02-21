#spawn                   pid = spawn(fn-> :gurka end)
#send/2                  send(pid, message)
#receive				 receive do pattern -> :gurka; pattern2 -> :gurka2; end
#receive will wait if the mailbox is empty or there is no matching pattern
#I can have multiple recieve in different functions. When a message is sent, it's put in a bucket that belongs to my process.
#

defmodule Philosopher do

	def start(hunger, left, right, name, ctrl, seed) do
		spawn_link(fn -> 
			:rand.seed(:exsss, {seed, seed, seed})
			Enum.each(1..hunger, fn(n)-> sleep(1000); IO.puts("#{name} wants to eat."); eat(left, right, name) end)
			send(ctrl, :done)
			IO.puts("\n\n#{name} has finished eating.\n")
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
		Chopstick.return(left, self())
		Chopstick.return(right, self())
	end

end
