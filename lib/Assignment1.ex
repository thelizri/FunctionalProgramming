defmodule Calculus do
  @type literal :: {:num, number} | {:var, atom}
   @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} |
   {:div, expr(), expr()} | {:exp, expr(), expr()} | {:sqrt, expr()} |
   {:neg, expr()} | {:sin, expr(), expr()} | {:cos, expr(), expr()} |
   {:ln, expr()} | literal
  #2x+3
  #{:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}
  #5x10x
  #{:mul, {:mul, {:num, 5}, {:var, :x}}, {:mul, {:num, 10}, {:var, :x}}}


  #Derivative basic rules
  def deriv({:num, _}, _) do
    {:num, 0}
  end
  def deriv({:var, v}, v) do
    {:num, 1}
  end
  def deriv({:var, _}, _) do
    {:num, 0}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1,v), e2}, {:mul, deriv(e2,v), e1}}
  end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1,v), deriv(e2,v)}
  end

  #Power rule
  def deriv({:exp, {:var, x}, {:num, n}}, x) do 
    {:mul, {:num, n}, {:exp, {:var, x}, {:num, n-1}}}
  end

  #Log e, ln(x)
  def deriv({:ln, {:var, x}}, x) when x > 0 do
    {:div, {:num, 1}, {:var, x}}
  end
  def deriv({:ln, {:var, _}}, _) do
    {:num, 0}
  end

  #1/x
  def deriv({:div, {:num, 1}, {:var, x}}, x) when x != 0 do
    {:neg, {:div, {:num, 1}, {:exp, {:var, x}, {:num, 2}}}}
  end
  def deriv({:div, {:num, 1}, {:var, _}}, _) do
    {:num, 0}
  end

  #sin(x)
  def deriv({:sin, {:var, x}}, x) do
    {:cos, x}
  end
  def deriv({:sin, {:var, _}}, _) do
    {:num, 0}
  end

  #square root of x
  def deriv({:sqrt, {:var, x}}, x) do
    {:mul, {:num, 1/2}, {:exp, {:var, x}, {:num, -1/2}}}
  end
  def deriv({:sqrt, {:var, _}}, _) do
    {:num, 0}
  end


  #Simplification
  #Pure numbers or variables
  def simplify({:num, a}) do
    {:num, a}
  end
  def simplify({:var, a}) do
    {:var, a}
  end

  #Addition
  def simplify({:add, {:num, 0}, e}) do
    simplify(e)
  end
  def simplify({:add, e, {:num, 0}}) do
    simplify(e)
  end

  def simplify({:add, {:num, a}, {:num, b}}) do
    {:num, a+b}
  end
  def simplify({:add, {:var, a}, {:var, b}}) do
    {:add, {:var, a}, {:var, b}}
  end
  def simplify({:add, {:var, a}, {:num, b}}) do
    {:add, {:var, a}, {:num, b}}
  end

  def simplify({:add, e1, e2}) do
    {:add, simplify(e1), simplify(e2)}
  end

  #Multiplication
  def simplify({:mul, {:num, 0}, _}) do
    {:num, 0}
  end
  def simplify({:mul, 0, {:num, 0}}) do
    {:num, 0}
  end

  def simplify({:mul, {:num, 1}, e}) do
    simplify(e)
  end
  def simplify({:mul, e, {:num, 1}}) do
    simplify(e)
  end

  def simplify({:mul, {:num, a}, {:num, b}}) do
    {:num, a*b}
  end
  def simplify({:mul, {:var, a}, {:var, b}}) do
    {:mul, {:var, a}, {:var, b}}
  end

  def simplify({:mul, {:num, a}, {:var, b}}) do
    {:mul, {:num, a}, {:var, b}}
  end
  def simplify({:mul, {:var, b}, {:num, a}}) do
    {:mul, {:num, a}, {:var, b}}
  end
  def simplify({:mul, {:mul, {:num, n1}, e2}, {:num, n2}}) do 
    {:mul, {:num, n1*n2}, simplify(e2)}
  end
  def simplify({:mul, {:mul, e2, {:num, n1}}, {:num, n2}}) do 
    {:mul, {:num, n1*n2}, simplify(e2)}
  end
  def simplify({:mul, {:num, n2}, {:mul, e2, {:num, n1}}}) do 
    {:mul, {:num, n1*n2}, simplify(e2)}
  end
  def simplify({:mul, {:num, n2}, {:mul, {:num, n1}, e2}}) do 
    {:mul, {:num, n1*n2}, simplify(e2)}
  end
  def simplify({:mul, e1, e2}) do 
    {:mul, simplify(e1), simplify(e2)}
  end

  #Other functions
  def simplify({:exp, e1, e2}) do 
    {:exp, simplify(e1), simplify(e2)}
  end
  def simplify({:div, e1, e2}) do 
    {:div, simplify(e1), simplify(e2)}
  end
  def simplify({:sqrt, e1}) do 
    {:sqrt, simplify(e1)}
  end
  def simplify({:sin, e1}) do 
    {:sin, simplify(e1)}
  end
  def simplify({:cos, e1}) do 
    {:cos, simplify(e1)}
  end
  def simplify({:neg, e1}) do 
    {:neg, simplify(e1)}
  end

  def callSimplify(e) do
    result = simplify(e)
    if e != result do
      simplify(result)
    else
      result
    end
  end


  def print({:num, x}) do "#{x}" end
  def print({:var, x}) do "#{x}" end
  def print({:neg, e}) do " - #{print(e)}" end
  def print({:sqrt, e}) do "sqrt(#{print(e)})" end
  def print({:add, e1, e2}) do "(#{print(e1)} + #{print(e2)})" end
  def print({:mul, e1, e2}) do "#{print(e1)} * #{print(e2)}" end
  def print({:exp, e1, e2}) do "#{print(e1)}^(#{print(e2)})" end

  def test() do
    test =
      {:add,
       {:mul, {:num, 4}, {:exp, {:var, :x}, {:num, 2}}},
       {:add, {:mul, {:num, 3}, {:var, :x}}, {:num, 42}}
     }
    IO.write("expression: #{print(test)}\n")

    der = deriv(test, :x)
    IO.write("derivative: #{print(der)}\n")

    simpl = callSimplify(der)
    IO.write("simplified: #{print(simpl)}\n")
  end

  def test2() do
    test =
      {:mul,
       {:mul, {:num, 4}, {:sqrt, {:var, :x}}},
       {:add, {:mul, {:num, 3}, {:var, :x}}, {:num, 42}}
     }
    IO.write("expression: #{print(test)}\n")

    der = deriv(test, :x)
    IO.write("derivative: #{print(der)}\n")

    simpl = callSimplify(der)
    IO.write("simplified: #{print(simpl)}\n")
  end

end