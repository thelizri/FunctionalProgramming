defmodule Day10 do

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day10.txt")
		content = String.split(input, "\r\n")
		execute_program(content)
	end

	def execute_program(content) do
		execute_program(content, 1, 1, 0)
	end

	def execute_program([], cycle, register, acc) do IO.puts("Cycle: #{cycle}, Acc: #{acc}") end

	def execute_program([head|rest], cycle, register, acc) do
		acc = add_to_acc(cycle, register, acc)
		print_status(cycle, register, acc)
		case head do
			"noop" -> execute_program(rest, cycle+1, register, acc)
			_ -> 
				[_, num] = String.split(head, " ")
				num = String.to_integer(num)
				acc = add_to_acc(cycle+1, register, acc)
				execute_program(rest, cycle+2, register+num, acc)
		end
	end

	def print_status(cycle, register, acc) do
		IO.puts("Cycle: #{cycle}, Value in register: #{register}, Accumulator: #{acc}")
	end

	def add_to_acc(cycle, register, acc) do
		cond do
			cycle > 220 -> acc
			rem(cycle-20, 40)==0 -> IO.puts(cycle); acc+cycle*register
			true -> acc
		end
	end
end