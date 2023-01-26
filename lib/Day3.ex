defmodule Day3 do
	#First half = Second half
	#a-z = 1-26, A-Z = 27-52

	def read() do
		{:ok, input} = File.read("lib/Day3.txt")
		content = String.split(input, "\r\n")
		list(content, 0)
	end

	def list([head], score) do
		length = String.length(head)
		length = Integer.floor_div(length, 2)
		{first, last} = String.split_at(head, length)
		boolMap = evalFirst(first)
		addValue = evalSecond(last, boolMap)
		score+addValue
	end

	def list([head|tail], score) do
		length = String.length(head)
		length = Integer.floor_div(length, 2)
		{first, last} = String.split_at(head, length)
		boolMap = evalFirst(first)
		addValue = evalSecond(last, boolMap)
		list(tail, score+addValue)
	end

	def getValueHashMap() do
		%{"a" => 1, "b" => 2, "c" => 3, 
			"d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9,
			"j" => 10, "k" => 11, "l" => 12, "m" => 13, "n" => 14, "o" => 15,
			"p" => 16, "q" => 17, "r" => 18, "s" => 19, "t" => 20, "u" => 21,
			"v" => 22, "w" => 23, "x" => 24, "y" => 25, "z" => 26, "A" => 27,
			"B" => 28, "C" => 29, "D" => 30, "E" => 31, "F" => 32, "G" => 33,
			"H" => 34, "I" => 35, "J" => 36, "K" => 37, "L" => 38, "M" => 39,
			"N" => 40, "O" => 41, "P" => 42, "Q" => 43, "R" => 44, "S" => 45,
			"T" => 46, "U" => 47, "V" => 48, "W" => 49, "X" => 50, "Y" => 51, "Z" => 52
		}
	end

	def getBoolHashMap() do
		%{"a" => false, "b" => false, "c" => false, 
			"d" => false, "e" => false, "f" => false, "g" => false, "h" => false, "i" => false,
			"j" => false, "k" => false, "l" => false, "m" => false, "n" => false, "o" => false,
			"p" => false, "q" => false, "r" => false, "s" => false, "t" => false, "u" => false,
			"v" => false, "w" => false, "x" => false, "y" => false, "z" => false, "A" => false,
			"B" => false, "C" => false, "D" => false, "E" => false, "F" => false, "G" => false,
			"H" => false, "I" => false, "J" => false, "K" => false, "L" => false, "M" => false,
			"N" => false, "O" => false, "P" => false, "Q" => false, "R" => false, "S" => false,
			"T" => false, "U" => false, "V" => false, "W" => false, "X" => false, "Y" => false, "Z" => false
		}
	end

	def evalFirst(string) do
		map = getBoolHashMap()
		charlist = String.split(string, "", trim: true)
		evalFirst(charlist, map)
	end

	def evalFirst([head], map) do
		Map.replace(map, head, true)
	end

	def evalFirst([head|rest], map) do
		map = Map.replace(map, head, true)
		evalFirst(rest, map)
	end

	def evalSecond(string, boolMap) do
		valueMap = getValueHashMap()
		charlist = String.split(string, "", trim: true)
		evalSecond(charlist, boolMap, valueMap, 0)
	end

	def evalSecond([head|rest], boolMap, valueMap, score) do
		{:ok, isVisited }= Map.fetch(boolMap, head)
		if isVisited do
			{:ok, value} = Map.fetch(valueMap, head)
			score + value
		else
			evalSecond(rest, boolMap, valueMap, score)
		end
	end

end