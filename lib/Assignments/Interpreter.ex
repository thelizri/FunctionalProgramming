defmodule Eager do

	################################################################################################################
	# Takes an expression and an environment and returns a data structure
	# Returns either {:ok, datastructure} or :error

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

	def eval_test() do
		:io.write(eval_expr({:atm, :a}, Env.new()))
		IO.write("\n")
		:io.write(eval_expr({:var, :x}, %{x: :a}))
		IO.write("\n")
		:io.write(eval_expr({:var, :x}, Env.new()))
		IO.write("\n")
		:io.write(eval_expr({:cons, {:var, :x}, {:atm, :b}}, %{x: :a}))
		IO.write("\n")
	end

	################################################################################################################
	# Takes a pattern, datastructure, and environment
	# Returns either {:ok, environment} or :fail

	def eval_match(:ignore, _expression, environment) do
		{:ok, environment}
	end

	def eval_match({:atm, id}, id, environment) do
		{:ok, environment}
	end

	def eval_match({:var, id}, str, env) do
	    case Env.lookup(id, env) do
	      nil -> {:ok, Env.add(id, str, env)}
	      {^id, ^str} -> {:ok, env} 
	      {_, _} -> :fail
	    end
  	end

  	def eval_match({:cons, left, right}, {strleft, strright}, env) do
		case eval_match(left, strleft, env) do
			:fail -> :fail
			{:ok, newEnv} -> eval_match(right, strright, newEnv)
		end
	end

	def eval_match(_, _, _) do
		:fail
	end

	def match_test() do
		:io.write(eval_match({:atm, :a}, :a, Env.new()))
		IO.write("\n")
		:io.write(eval_match({:var, :x}, :a, Env.new()))
		IO.write("\n")
		:io.write(eval_match({:var, :x}, :a, %{x: :a}))
		IO.write("\n")
		:io.write(eval_match({:var, :x}, :a, %{x: :b}))
		IO.write("\n")
		:io.write(eval_match({:cons, {:var, :x}, {:var, :x}}, {:a, :b}, Env.new()))
		IO.write("\n")
	end

end