defmodule Evaluation do

	def create_environment([]) do nil end

	def create_environment([{key, value}|rest]) do
		map = %{key => value}
		create_environment(rest, map)
	end

	def create_environment(_) do nil end

	def create_environment([], map) do map end

	def create_environment([{key, value}|rest], map) do
		map = Map.put(map, key, value)
		create_environment(rest, map)
	end

	def eval(expression, environment) do
		#:io.write(expression)
		#IO.write("\n")
		result=evaluate(expression, environment)
		if result == expression do
			result
		else
			eval(result, environment)
		end
	end


	#Integers {:num, n}
	#Variables {:var, a}
	#Rational expressions {:q, a, b}
	def evaluate({:num, n}, _environment) do {:num, n} end
	def evaluate({:var, x}, environment) do {:num, environment[x]} end
	def evaluate({:q, a, b}, _environment) do
		gcd = Integer.gcd(a, b)
	 	a = div(a, gcd)
	 	b = div(b, gcd)
	 	{:q, a, b}
	end

	#Addition
	def evaluate({:add, a, b}, environment) do add(a, b, environment) end

	#Subtraction
	def evaluate({:sub, a, b}, environment) do sub(a, b, environment) end

	#Multiplication
	def evaluate({:mul, a, b}, environment) do mul(a, b, environment) end

	#Division
	def evaluate({:div, a, b}, environment) do div(a, b, environment) end

	#Addition
	def add({:num, a}, {:num, b}, _) do {:num, a+b} end
	def add({:num, a}, {:q, n, m}, _) do {:q, a*m+n, m} end
	def add({:q, n, m}, {:num, a}, _) do {:q, a*m+n, m} end
	def add(a, b, env) do {:add, evaluate(a, env), evaluate(b, env)} end

	#Subtraction
	def sub({:num, a}, {:num, b}, _) do {:num, a-b} end
	def sub({:num, a}, {:q, n, m}, _) do {:q, a*m-n, m} end
	def sub({:q, n, m}, {:num, a}, _) do {:q, a*m-n, m} end
	def sub(a, b, env) do {:sub, evaluate(a, env), evaluate(b, env)} end

	#Multiplication
	def mul({:num, a}, {:num, b}, _) do {:num, a*b} end
	def mul({:num, a}, {:q, n, m}, _) do {:q, n*a, m} end
	def mul({:q, n, m}, {:num, a}, _) do {:q, n*a, m} end
	def mul(a, b, env) do {:mul, evaluate(a, env), evaluate(b, env)} end

	#Division
	def div({:num, a}, {:num, b}, _) do {:q, a, b} end
	def div({:num, a}, {:q, n, m}, _) do {:q, m*a, n} end
	def div({:q, n, m}, {:num, a}, _) do {:q, n, m*a} end
	def div(a, b, env) do {:div, evaluate(a, env), evaluate(b, env)} end

	def test() do
		#2x+3+1/2
		exp = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}
		env = create_environment([{:x, 10}])
		eval(exp, env) |> :io.write
	end

	def test2() do
		#(7x-3)/2
		exp = {:div, {:sub, {:mul, {:num, 7}, {:var, :x}}, {:num, 3}}, {:num, 2}}
		env = create_environment([{:x, 10}])
		eval(exp, env) |> :io.write
	end

end