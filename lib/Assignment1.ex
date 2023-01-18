defmodule Calculus do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} | literal()
  #2x+3
  #{:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}

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
  def deriv({:exp, {:var, x}, {:num, n}}) do 
    {:mul, {:num, n}, {:exp, {:var, x}, {:num, n-1}}}
  end
  #Log e, ln(x)
  def deriv({:ln, {:num, x}}) when x > 0 do
    {:div, {:num, 1}, {:num, x}}
  end
  #1/x
  def deriv({:div, {:num, 1}, {:num, x}}) when x != 0 do
    {:neg, {:div, {:num, 1}, {:num, x*x}}}
  end

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
    simplify({:add, simplify(e1), simplify(e2)})
  end

  #Multiplication
  def simplify({:mul, {:num, 0}, _}) do
    {:num, 0}
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
  def simplify({:mul, e1, e2}) do
    simplify({:mul, simplify(e1), simplify(e2)})
  end

end