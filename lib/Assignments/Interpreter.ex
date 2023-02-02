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

	################################################################################################################
	# Takes a sequence
	# Returns an evaluated expression
	def eval_seq([exp], env) do
		eval_expr(exp, env)
	end

	def eval_seq([{:match, pattern, expr} | rest], environment) do
		case eval_expr(expr, environment) do
			:error -> :error
			{:ok, datastructure}-> newEnv = eval_scope(pattern, environment)
				case eval_match(pattern, datastructure, newEnv) do
					:fail -> :error
					{:ok, env} -> eval_seq(rest, env)
				end
		end
	end

	def seq_test() do
		# x = :a; y = {x, :b}; {_, z} = y; z
		# Elixir evaluates above to -> :b
	    seq = [{:match, {:var, :x}, {:atm, :a}}, {:match, {:var, :y}, {:cons, {:var, :x},
	     {:atm, :b}}}, {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}}, {:var, :z}]
	    eval_seq(seq, Env.new())
  	end

	################################################################################################################
	# Extract variables from a pattern
	# Returns a list of variables

	def eval_scope(pattern, environment) do
		Env.remove(extract_vars(pattern), environment)
	end

	def extract_vars(pattern) do
    	extract_vars(pattern, [])
  	end

    def extract_vars({:atm, _}, variables) do variables end
    def extract_vars(:ignore, variables) do variables end
    def extract_vars({:var, var}, variables) do
    	[var | variables]
    end
    def extract_vars({:cons, head, tail}, variables) do
   		extract_vars(tail, extract_vars(head, variables))
    end

    ################################################################################################################
	# Evaluate cases
	# 1. First evaluate expression to structure.
	# 2. Try to match pattern in clause to structure.
	# 3. Move on if it doesn't match. If match, execute sequence clause contains.

	def eval_expr({:case, expressive, clauses}, env) do
	    case eval_expr(expressive, env) do
	      :error -> :error
	      {:ok, str} -> eval_cls(clauses, str, env)
	    end
  	end

  	def eval_cls([], _, _, _) do
		:error
	end

	def eval_cls([{:clause, pattern, sequence} | clauses], structure, environment) do
	    case eval_match(pattern, structure, eval_scope(pattern, environment)) do
	    	:fail -> eval_cls(clauses, structure, environment)
	    	{:ok, newEnvironment} -> eval_seq(sequence, newEnvironment)
	    end
  	end


  	def test_clauses() do
  		# x = :a
  		# case x do
		# 	:b -> [:ops]
		# 	:a -> [:yes]
		# end
  		seq = [{:match, {:var, :x}, {:atm, :a}}, 
  		{:case, {:var, :x}, 
  		[{:clause, {:atm, :b}, [{:atm, :ops}]},
		{:clause, {:atm, :a}, [{:atm, :yes}]}]}]
		eval_seq(seq, Env.new())
	end

	################################################################################################################
	# Evaluate lambda expressions
	# {:lambda, parameters, free, sequence}
	# {:closure, parameters, sequence, environment}

	def eval_expr({:lambda, parameters, free, sequence}, environment) do
		case Env.closure(free, environment) do
			:error -> :error
			closure -> {:ok, {:closure, parameters, sequence, closure}}
		end
	end

	def eval_expr({:apply, expression, arguments}, environment) do
		case eval_expr(expression, environment) do
			:error -> :error
			{:ok, {:closure, parameters, sequence, closure}} -> 
				case eval_args(arguments, environment) do
					:error -> :error
					{:ok, strs} -> 
						env = Env.args(parameters, strs, closure)
						eval_seq(sequence, env)
				end
			{:ok, _} -> :error
		end
	end

	def eval_args(args, env) do
    	eval_args(args, env, [])
  	end
  
  	def eval_args([], _, strs) do {:ok, Enum.reverse(strs)} end

  	def eval_args([expr | exprs], env, strs) do
	    case eval_expr(expr, env) do
	    	:error -> :error
	    	{:ok, str} -> eval_args(exprs, env, [str|strs]) 
	    end
  	end


	def test_lambda() do
		# x = :a
		# f = fn(y) -> {x, y} end
		# f.(:b)
		# Elixir evaluates this to -> {:a, [:b]}
		seq = [{:match, {:var, :x}, {:atm, :a}}, {:match, {:var, :f},
				{:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
				{:apply, {:var, :f}, [{:atm, :b}]}]
		eval_seq(seq, Env.new())
	end


	################################################################################################################
	# Evaluate named functions

	def eval_expr({:fun, id}, env) do
		{par, seq} = apply(Prgm, id, [])
		{:ok, {:closure, par, seq, Env.new()}}
	end

	def test_named() do
		# x = {:a, {:b, []}}
		# y = {:c, {:d, []}}
		seq = [{:match, {:var, :x},
			{:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
			{:match, {:var, :y},
			{:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
			{:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}
			]
		eval_seq(seq, Env.new())
	end

	################################################################################################################
	# Evaluate 

	def eval(seq) do
    	# a new environment is created
    	eval_seq(seq, Env.new())
  	end

end