defmodule Storage do

	def run() do
		spawn(fn -> loop(%{}) end)
	end

	defp loop(map) do
	    receive do
	    	{:get, key, caller} ->
	        	send caller, Map.get(map, key); loop(map)
	    	{:put, key, value} -> 
	    		loop(Map.put(map, key, value))
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