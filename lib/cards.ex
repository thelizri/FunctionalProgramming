defmodule Cards do
  def create_deck do 
    #values = ["Ace","Two","Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits do
      suit
    end
  end

  def print_n_times(message, n) when n > 0 do
    IO.puts(message)
    print_n_times(message, n-1)
  end

  def print_n_times(_message, _n) do
    :ok
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, hand) do
    Enum.member?(deck,hand)
  end


  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do
    fib(n-1)+fib(n-2)
  end

end

defmodule Calc do
  def add(x,y) do
    if elem(x,0)==:num and elem(y,0)==:num do
      _tuple = {:num, elem(x,1)+elem(y,1)}
    else
      _tuple = {:num, 99}
    end
  end
end

defmodule Calculus do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} | literal()
  #2x+3
  #{:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}
  def deriv({:num, _}, _) do
    0
  end
  def deriv({:var, v}, v) do
    1
  end
  def deriv({:var, _}, _) do
    0
  end
  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1,v), e2}, {:mul, deriv(e2,v), e1}}
  end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1,v), deriv(e2,v)}
  end
end