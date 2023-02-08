defmodule Day10 do

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day10.txt")
		content = String.split(input, "\r\n")
		execute_part2(content, 1, 1)
	end

	def execute_program(content) do
		execute_program(content, 1, 1, 0)
	end

	def execute_program([], cycle, register, acc) do IO.puts("Cycle: #{cycle}, Acc: #{acc}") end

	def execute_program([head|rest], cycle, register, acc) do
		acc = add_to_acc(cycle, register, acc)
		case head do
			"noop" -> execute_program(rest, cycle+1, register, acc)
			_ -> 
				[_, num] = String.split(head, " ")
				num = String.to_integer(num)
				acc = add_to_acc(cycle+1, register, acc)
				execute_program(rest, cycle+2, register+num, acc)
		end
	end

	def add_to_acc(cycle, register, acc) do
		cond do
			cycle > 220 -> acc
			rem(cycle-20, 40)==0 -> acc+cycle*register
			true -> acc
		end
	end

	###################################################################################
	# Part 2

	def execute_part2([], cycle, register) do IO.puts("\nDone") end
	def execute_part2([head|rest], cycle, register) do
		render(cycle, register)
		case head do
			"noop" -> execute_part2(rest, cycle+1, register)
			_ -> 
				[_, num] = String.split(head, " ")
				num = String.to_integer(num)
				render(cycle+1, register)
				execute_part2(rest, cycle+2, register+num)
		end
	end

	def render(cycle, register) do
		value = register
		cycle = rem(cycle, 40)
		cond do
			register <= cycle and cycle <= register+2 -> IO.write("#")
			true -> IO.write(".")
		end
		cond do
			rem(cycle, 40) == 0 -> IO.puts("")
			true -> nil
		end
	end

end