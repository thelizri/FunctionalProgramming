defmodule Chopstick do

	def start do
		stick = spawn_link(fn -> available() end)
	end

	defp available() do
		receive do
			{:request, ref} -> send(from, {:ok, ref}); gone(ref)
			:quit -> :ok
		end
	end

	defp gone(ref) do
		receive do
			{:return, ^ref} -> available()
			:quit -> :ok
		end
	end

	#########################################################################################
	# Interface
	# Add unique identifier to message make_ref()
	def request(stick, ref) do
		send(stick, {:request, ref})
	end

	def return(stick, ref) do
		send(stick, {:return, ref})
	end

	def quit(stick) do
		send(stick, :quit)
	end
end