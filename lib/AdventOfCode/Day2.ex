defmodule Day2 do
	# First column opponent
	# A = Rock, B = Paper, C = Scissors

	# Second column me
	# X = Rock, Y = Paper, Z = Scissors

	#Score, Rock=1, Paper=2, Scissors=3, Loss=0, Draw=3, Win=6

	def getHandScore(hand) do
		case hand do
			:rock -> 1
			:paper -> 2
			:scissors -> 3
		end
	end

	def stringToAtom(string) do
		case string do
			"A" -> :rock
			"B" -> :paper
			"C" -> :scissors
			"X" -> :rock
			"Y" -> :paper
			"Z" -> :scissors
		end
	end

	def getScoreMatch(x, x) do
		3
	end

	def getScoreMatch(:rock, x) do
		case x do
			:paper -> 6
			:scissors -> 0
		end
	end

	def getScoreMatch(:paper, x) do
		case x do
			:rock -> 0
			:scissors -> 6
		end
	end

	def getScoreMatch(:scissors, x) do
		case x do
			:rock -> 6
			:paper -> 0
		end
	end

	def totalScore(op, me) do
		hand = getHandScore(me)
		match = getScoreMatch(op, me)
		hand+match
	end

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day2.txt")
		content = String.split(input, "\r\n")
		evaluate_row2(content, 0)
	end

	def evaluate_row([head], score) do
		[op, me] = String.split(head, " ")
		op = stringToAtom(op)
		me = stringToAtom(me)
		score + totalScore(op, me)
	end

	def evaluate_row([head|rest], score) do
		[op, me] = String.split(head, " ")
		op = stringToAtom(op)
		me = stringToAtom(me)
		result = score + totalScore(op, me)
		evaluate_row(rest, result)
	end

	#Part2
	#X = lose, Y = draw, Z = Win
	def getMyHand(opponent, "X") do
		case opponent do
			:rock -> :scissors
			:paper -> :rock
			:scissors -> :paper
		end
	end

	def getMyHand(opponent, "Y") do
		opponent
	end

	def getMyHand(opponent, "Z") do
		case opponent do
			:rock -> :paper
			:paper -> :scissors
			:scissors -> :rock
		end
	end

	def evaluate_row2([head], score) do
		[op, me] = String.split(head, " ")
		op = stringToAtom(op)
		me = getMyHand(op, me)
		score + totalScore(op, me)
	end

	def evaluate_row2([head|rest], score) do
		[op, me] = String.split(head, " ")
		op = stringToAtom(op)
		me = getMyHand(op, me)
		result = score + totalScore(op, me)
		evaluate_row2(rest, result)
	end

end