#spawn                   pid = spawn(fn-> :gurka end)
#send/2                  send(pid, message)
#receive				 receive do pattern -> :gurka; pattern2 -> :gurka2; end
#receive will wait if the mailbox is empty or there is no matching pattern
#I can have multiple recieve in different functions. When a message is sent, it's put in a bucket that belongs to my process.
#

defmodule Philosopher do

	def start(hunger, left, right, name, ctrl, seed) do
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
		sleep(300)
		Chopstick.request(right, self())
		receive do
			:ok -> IO.puts("#{name} received right chopstick!")
		end
		IO.puts("#{name} eats a bite")
		Chopstick.return(left)
		Chopstick.return(right)
	end

	def aeat(left, right, name) do
		Chopstick.request(left, self())
		Chopstick.request(right, self())
		granted(2, name)
		IO.puts("#{name} eats a bite")
		Chopstick.return(left)
		Chopstick.return(right)
	end

	def granted(num, name) when num > 0 do
		receive do
			:ok -> IO.puts("#{name} received a chopstick!"); granted(num-1, name)
		end
	end

	def granted(_, _) do :ok end

end
