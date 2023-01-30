defmodule Day7 do

	def read() do
		{_status, content} = File.read("lib/AdventOfCode/Day7.txt")
		list = String.split(content, "\r\n")
		execute(list, new())
	end

	def execute([], tree) do
		final(tree)
	end

	def execute([head|rest], tree) do
		case String.split(head, " ") do
			["$", "cd", "/"] -> IO.write("Root\n")
			["$", "cd", ".."] -> IO.write("Go back\n")
			["$", "cd", name] -> IO.write("Enter directory: #{name}\n")
			["$", "ls"] -> IO.write("List\n")
			["dir", name] -> IO.write("List directory: #{name}\n")
			[size, name] -> IO.write("List file: #{name}, of size: #{size}\n")
		end
		execute(rest, tree)
	end


	def final(tree) do
		tree
	end

	def new() do
		{"/", :unknown, []}
	end

	def add({a, b, list}, new) do
		{a, b, list ++ new}
	end

	def down([{target, size, list}|rest], target) do
		{target, size, list}
	end

	def down([head|rest], target) do
		down(rest, target)
	end

end