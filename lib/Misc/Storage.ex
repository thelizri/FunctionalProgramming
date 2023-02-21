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