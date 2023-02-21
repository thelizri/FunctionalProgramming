#spawn                   pid = spawn(fn-> :gurka end)
#send/2                  send(pid, message)
#receive				 receive do pattern -> :gurka; pattern2 -> :gurka2; end
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
			{key, value} -> IO.inspect(value)
			something -> IO.inspect(something)
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
			{:request, from} -> send(from, :gone); gone()
			:quit -> :ok
		end
	end

end