defmodule Day7 do

	def read() do
		{_status, content} = File.read("lib/AdventOfCode/Day7.txt")
		list = String.split(content, "\r\n")
		execute(list, %{:root => {nil, :size, []}}, nil)
	end

	def execute([], map, _) do
		final(map)
	end

	def execute([head|rest], map, current_directory) do
		{map, current_directory} = case String.split(head, " ") do
			["$", "cd", "/"] -> {map, :root}
			["$", "cd", ".."] -> {map, getParent(map, current_directory)}
			["$", "cd", name] -> {map, name}
			["$", "ls"] -> {map, current_directory}
			["dir", name] -> {addDirectory(map, current_directory, name), current_directory}
			[size, _name] -> {addFile(map, current_directory, size), current_directory}
		end
		execute(rest, map, current_directory)
	end

	def final(map) do
		map
	end

	def getParent(map, directory) do
		{parent, _, _} = map[directory]
		parent
	end

	def addDirectory(map, parent, newDir) do
		map = Map.put(map, newDir, {parent, :size, []})
		{a, b, list} = map[parent]
		list = list ++ [newDir]
		Map.put(map, parent, {a, b, list})
	end

	def addFile(map, directory, size) do
		{a, b, list} = map[directory]
		num = String.to_integer(size)
		list = list ++ [num]
		Map.put(map, directory, {a, b, list})
	end

end