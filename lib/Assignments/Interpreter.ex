defmodule Eager do

	#eval_expr/2 takes an expression and an environment and returns a data structure

	def eval_expr({:atm, id}, _environment) do {:ok, id} end

	def eval_expr({:var, id}, env) do
		case Env.lookup(id, env) do
			nil -> :error
		{_, str} -> {:ok, str}
		end
	end

    def eval_expr({:cons, left, right}, env) do
		case eval_expr(left, env) do
			:error -> :error
			{:ok, str1} ->
				case eval_expr(right, env) do
					:error -> :error
					{:ok, str2} -> {:ok, {str1, str2}}
				end
		end
	end


end