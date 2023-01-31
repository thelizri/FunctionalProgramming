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
		{this, _} = findSize(:root, map)
		Map.to_list(this)
		|> findSum(0)
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

	def findSize(dir, map) do
		{parent, _, list} = map[dir]
		{map, result} = forLoop(list, map, [])
		size = Enum.sum(result)
		IO.write("Directory: #{dir}. Size: #{size}\n")
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

end