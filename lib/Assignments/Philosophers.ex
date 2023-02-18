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