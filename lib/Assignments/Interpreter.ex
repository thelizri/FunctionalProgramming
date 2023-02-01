defmodule Eager do

	def eval_expr({:atm, id}, env) do 
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
end