#spawn                   pid = spawn(fn-> :gurka end)
#send/2                  send(pid, message)
#receive				 receive do pattern -> :gurka; pattern2 -> :gurka2; end
#receive will wait if the mailbox is empty or there is no matching pattern
#I can have multiple recieve in different functions. When a message is sent, it's put in a bucket that belongs to my process.
#

defmodule Philosopher do

	def start(hunger, left, right, name, ctrl, sleep) do
		spawn_link(fn -> 
			Enum.each(1..hunger, fn(n)-> sleep(sleep); IO.puts("#{name} wants to eat."); eat(left, right, name) end)
			send(ctrl, :done)
			IO.puts("\n\n#{name} has finished eating.\n")
			end)#
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

	def sleep(0) do :ok end
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end

	###########################################################################################
	# Asynchronous
	# Add patience variable

	def async_start(hunger, left, right, name, ctrl, sleep, timeout) do
		spawn_link(fn -> 
			async_run(hunger, left, right, name, sleep, timeout)
			send(ctrl, :done)
			IO.puts("\n\n#{name} has finished eating.\n")
			end)#
	end

	def async_run(0, left, right, name, sleep, timeout) do IO.puts("#{name} has finished eating") end
	def async_run(hunger, left, right, name, sleep, timeout) do
		sleep(sleep)
		IO.puts("#{name} wants to eat.")
		case async_eat(left, right, name, timeout) do
			:timeout -> async_run(hunger, left, right, name, sleep, timeout)
			:ok -> async_run(hunger-1, left, right, name, sleep, timeout)
		end
	end

	def async_eat(left, right, name, timeout) do
		Chopstick.request(left, self())
		Chopstick.request(right, self())
		case granted(2, timeout, []) do
			{:timeout, own} ->
				IO.puts("#{name} does not eat a bite")
				Enum.each(own, fn(pid)->Chopstick.return(pid, self()) end)
				:timeout
			{:ok, own} ->
				IO.puts("#{name} eats a bite")
				Enum.each(own, fn(pid)->Chopstick.return(pid, self()) end)
				:ok
		end
	end

	def granted(0, timeout, own) do {:ok, own} end
	def granted(n, timeout, own) do
		receive do
			{:ok, pid} -> granted(n-1, timeout, [pid]++own)
		after
			timeout -> {:timeout, own}
		end
	end

end
