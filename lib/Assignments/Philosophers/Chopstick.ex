defmodule Chopstick do

	def start do
		stick = spawn_link(fn -> available() end)
	end

	defp available() do
		receive do
			{:request, from} -> send(from, {:ok, self()}); gone(from)
			:quit -> :ok
		end
	end

	defp gone(from) do
		receive do
			{:return, ^from} -> available()
			:quit -> :ok
		end
	end

	#########################################################################################
	# Interface
	def request(stick, from) do
		send(stick, {:request, from})
	end

	def return(stick, from) do
		send(stick, {:return, from})
	end

	def quit(stick) do
		send(stick, :quit)
	end
end