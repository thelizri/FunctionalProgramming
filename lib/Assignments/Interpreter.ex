defmodule Eager do

	def eval_expr({:atm, id}, _env) do 
		{:ok, id}
	end

	def eval_expr({:var, id}, env) do
		case Env.lookup(id, env) do
			nil -> :error
			{_, str} -> {:ok, str}
		end
	end

	def eval_expr({:cons, a, b}, env) do
		case {eval_expr(a, env), eval_expr(b, env)} do
			{:error, _} -> :error
			{_, :error} -> :error
			{{:ok, str1},{:ok, str2}} -> {:ok, str1, str2}
		end
	end

	def eval_match({:atm, id}, id, env) do {:ok, env} end
	def eval_match({:var, key}, value, env) do 
		cond do
			is_atom(key) and is_atom(value) -> {:ok, Env.add(key, value, env)}
			true -> :error
		end
	end 
end