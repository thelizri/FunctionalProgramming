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