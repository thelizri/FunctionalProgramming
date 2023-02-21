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
	def request(stick) do
		send(stick, {:request, self()})
		receive do
			:ok -> :ok
		end
	end

	def return(stick) do
		send(stick, :return)
	end

	def quit(stick) do
		send(stick, :quit)
	end
end

defmodule Philosopher do

	def start(left, right, hunger, name, ctrl) do
		spawn_link(fn -> 
			Enum.each(1..hunger, fn(n)-> sleep(1000); eat(left, right, name) end)
			send(ctrl, :done)
			end)
	end

	def sleep(0) do :ok end
	def sleep(t) do
		:timer.sleep(:rand.uniform(t))
	end

	def eat(left, right, name) do
		Chopstick.request(left)
		receive do
			:ok -> IO.puts("#{name} received left chopstick!")
		end
		Chopstick.request(right)
		receive do
			:ok -> IO.puts("#{name} received right chopstick!")
		end
	end
end

