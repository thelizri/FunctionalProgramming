defmodule Day7 do

	def read() do
		{_status, content} = File.read("lib/AdventOfCode/Day7.txt")
		list = String.split(content, "\r\n")
		execute(list, %{"root/" => {nil, :size, []}}, "root/")
	end

	def execute([], map, _) do
		final(map)
	end

	def execute([head|rest], map, current_directory) do
		{map, current_directory} = case String.split(head, " ") do
			["$", "cd", "/"] -> {map, "root/"}
			["$", "cd", ".."] -> {map, getParent(map, current_directory)}
			["$", "cd", name] -> {map, getDirectoryName(current_directory, name)}
			["$", "ls"] -> {map, current_directory}
			["dir", name] -> {addDirectory(map, current_directory, name), current_directory}
			[size, _name] -> {addFile(map, current_directory, size), current_directory}
		end
		execute(rest, map, current_directory)
	end

	def getDirectoryName(parent, child) do
		parent <> "/" <> child
	end

	def final(map) do
		{this, _} = findSize("root/", map)
		list = Map.to_list(this)
		neededSpace = findSizeOfRoot(list)
		findPossibleDirectories(list, neededSpace, [])
	end

	def findSum([], sum) do
		sum
	end

	def findSum([head|list], sum) do
		{_, {_, size, _}} = head
		if size <= 100000 do
			findSum(list, size+sum)
		else
			findSum(list, sum)
		end
	end

	def getParent(map, directory) do
		{parent, _, _} = map[directory]
		parent
	end

	def addDirectory(map, parent, newDir) do
		key = parent <> "/" <> newDir
		map = Map.put(map, key, {parent, :size, []})
		{a, b, list} = map[parent]
		list = list ++ [key]
		Map.put(map, parent, {a, b, list})
	end

	def addFile(map, directory, size) do
		{a, b, list} = map[directory]
		num = String.to_integer(size)
		list = list ++ [num]
		Map.put(map, directory, {a, b, list})
	end

	def findSize(dir, map) do
		{parent, _, list} = map[dir]
		{map, result} = forLoop(list, map, [])
		size = Enum.sum(result)
		map = Map.put(map, dir, {parent, size, list})
		{map, size}
	end

	def forLoop([], map, result) do
		{map, result}
	end

	def forLoop([head|rest], map, result) do
		{map, result} = if is_number(head) do
			{map, result ++ [head]}
		else
			{map, size} = findSize(head, map)
			{map, result ++ [size]}
		end
		forLoop(rest, map, result)
	end

	#Part 2

	def findSizeOfRoot([head|rest]) do
		{name, {_parent, size, _}} = head
		if name == "root/" do
			unused = 70000000 - size
			needed = 30000000 - unused
		else
			findSizeOfRoot(rest)
		end
	end

	def findPossibleDirectories([], neededSize, result) do
		Enum.sort(result)
	end

	def findPossibleDirectories([head|rest], neededSize, result) do
		{_, {_, size, _}} = head
		if size >= neededSize do
			result = result ++ [size]
			findPossibleDirectories(rest, neededSize, result)
		else
			findPossibleDirectories(rest, neededSize, result)
		end
	end

end