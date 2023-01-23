defmodule Cards do
  def create_deck do 
    values = ["Ace","Two","Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits do
      for value <- values do
        "#{suit} and #{value}"
      end
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

  def test({:var, :a}) do
    {:var, :a}
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