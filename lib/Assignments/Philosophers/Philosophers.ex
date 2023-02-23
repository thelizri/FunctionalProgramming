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
	# We need to keep track of references make_ref()

	def async_start(hunger, left, right, name, ctrl, sleep, timeout) do
		spawn_link(fn -> 
			ref = make_ref()
			async_run(hunger, left, right, name, sleep, timeout, ref)
			send(ctrl, :done)
			IO.puts("\n\n#{name} has finished eating.\n")
			end)#
	end

	def async_run(0, left, right, name, sleep, timeout, ref) do IO.puts("#{name} has finished eating") end
	def async_run(hunger, left, right, name, sleep, timeout, ref) do
		sleep(sleep)
		IO.puts("#{name} wants to eat.")
		case async_eat(left, right, name, timeout, ref) do
			:timeout -> async_run(hunger, left, right, name, sleep, timeout, make_ref())
			:ok -> async_run(hunger-1, left, right, name, sleep, timeout, ref)
		end
	end

	def async_eat(left, right, name, timeout, ref) do
		Chopstick.request(left, self(), ref)
		Chopstick.request(right, self(), ref)
		case granted(2, timeout, ref) do
			:timeout ->
				IO.puts("#{name} does not eat a bite")
				Chopstick.return(left, ref)
				Chopstick.return(right, ref)
				:timeout
			:ok ->
				IO.puts("#{name} eats a bite")
				Chopstick.return(left, ref)
				Chopstick.return(right, ref)
				:ok
		end
	end

	def granted(0, timeout, ref) do :ok end
	def granted(n, timeout, ref) do
		receive do
			{:ok, ^ref} -> granted(n-1, timeout, ref)
		after
			timeout -> :timeout
		end
	end

end
