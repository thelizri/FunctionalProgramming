defmodule Cards do
  def create_deck do 
    values = ["Ace","Two","Three", "Four", "Five", "Six", "Seven"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
        "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, hand) do
    Enum.member?(deck,hand)
  end

  def deal_cards(deck, handsize) do
    {hand, _rest} = Enum.split(deck, handsize)
    hand
  end

  def save_deck(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def read_deck(filename) do
    {_status, binary} = File.read(filename)
    :erlang.binary_to_term(binary)
  end

end