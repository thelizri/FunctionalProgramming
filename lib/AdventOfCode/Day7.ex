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
		cond do
			head == "$ cd /" -> IO.write("Go to root\n")
			head == "$ cd .." -> IO.write("Move up\n")
			head == "$ ls" -> IO.write("List\n")
			Regex.match?(~r/dir [a-zA-Z]+/, head) -> IO.write("Add directory\n")
			Regex.match?(~r/\$ cd [a-zA-Z]+/, head) -> IO.write("Move into directory\n")
			Regex.match?(~r/\d+ .+/, head) -> IO.write("Add file\n")
			true -> IO.write("Unrecognized\n")
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