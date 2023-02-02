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
			{{:ok, str1},{:ok, str2}} -> {:ok, {str1, str2}}
		end
	end




	def eval_match(:ignore, _, env) do {:ok, env} end

	def eval_match({:atm, id}, id, env) do {:ok, env} end
	def eval_match({:var, key}, value, env) do 
		if is_atom(key) and is_atom(value) do
			case Env.lookup(key, env) do
				nil -> {:ok, Env.add(key, value, env)}
				{_, ^value} -> {:ok, env}
				{_, _} -> :fail
			end
		else
			:error
		end
	end 

	def eval_match({:cons, {:var, x}, {:var, x}}, {a, a}, env) do 
		eval_match({:var, x}, a, env)
	end
	
	def eval_match({:cons, {:var, x}, {:var, x}}, {_a, _b}, _) do :fail end

	def eval_match(_, _, _) do :fail end





	def extract_vars(pattern) do
		extract_vars(pattern, [])
	end

	def extract_vars({:atm, _}, result) do
		result
	end

	def extract_vars(:ignore, result) do
		result
	end

	def extract_vars({:var, x}, result) do
		[x | result]
	end

	def extract_vars({:cons, head, tail}, vars) do
    	extract_vars(tail, extract_vars(head, vars))
  	end





	def eval_scope(pattern, env) do
		Env.remove(extract_vars(pattern), env)
	end






	def eval_seq([expr], env) do
		eval_expr(expr, env)
	end

	#def eval_seq([{:match, ..., ...} | ...], ...) do end

  
#seq = [{:match, {:var, :x}, {:atm, :a}}, {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}}, {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}}, {:var, :z}]

#[{:match, {:var, :x}, {:atm, :a}}]
end