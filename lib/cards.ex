defmodule Cards do
  def create_deck do 
    values = ["Ace","Two","Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits do
      suit
    end
  end

  def print_n_times(message, n) when n > 0 do
    IO.puts(message)
    print_n_times(message, n-1)
  end

  def print_n_times(message, n) do
    :ok
  end



  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, hand) do
    Enum.member?(deck,hand)
  end
end
