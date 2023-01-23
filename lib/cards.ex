defmodule Cards do
  @moduledoc """
    Provides methods for handling and dealing a deck of cards
  """

  @doc """
  Returns a list of strings representing a deck
  """
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

  @doc """
    Determines whether a deck contains a given card 

    ## Examples

        iex> deck = Cards.create_deck()
        iex> Cards.contains?(deck, "Three of Spades")
        true
  """
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

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file does not exist"
    end
  end

  def print_tuple(tuple) do
    :io.write(tuple)
  end

  #Pipe operator
  #Doing it without
  def create_hand(handsize) do
    deck = create_deck()
    deck = shuffle(deck)
    _hand = deal_cards(deck, handsize)
  end

  #Doing it with pipe operator
  def pipe_hand(handsize) do
    create_deck() 
    |> shuffle()
    |> deal_cards(handsize)
  end

end