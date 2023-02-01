defmodule Env do

	def new() do
		Map.new()
	end

	def add(id, str, env) do
		Map.put(env, id, str)
	end

	def lookup(id, env) do
		Map.fetch(env, id) |>
		case do
			:error -> nil
			{:ok, str} -> {id, str}
		end
	end

	def remove(ids, env) do
		Map.drop(env, ids)
	end


end