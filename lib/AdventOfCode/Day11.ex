defmodule Day11 do


	def read(numofrounds) do
		{:ok, content} = File.read("lib/AdventOfCode/Day11.txt")
		content = String.split(content, "\r\n\r\n")
		map = Map.new()
		map = parse_block(content, map)
		map = allrounds(numofrounds, map)
		for num <- 0..7 do {:ok, value} = Map.fetch(map, {num, :inspections}); value end
		|> Enum.sort |> getLastTwo()
	end

	def getLastTwo([max2, max1]) do max1*max2 end
	def getLastTwo([head|rest]) do getLastTwo(rest) end

	#How do I reduce the numbers such that they don't lost fidelity?
	def operations(monkey, item) do
		case monkey do
			0 -> item * 11
			1 -> item + 4
			2 -> item * item
			3 -> item + 2
			4 -> item + 3
			5 -> item + 1
			6 -> item + 5
			7 -> item * 19
		end #Part 1: |> div(3) 
		#Part 2: Myster number |> rem(746130)
	end

	def execute_one_monkey(number, map) do
		{:ok, items} = Map.fetch(map, {number, :items})
		{:ok, inspections} = Map.fetch(map, {number, :inspections})
		map = Map.put(map, {number, :inspections}, inspections+length(items))
		map = Map.put(map, {number, :items}, [])
		items = for item <- items do
			operations(number, item)
		end
		monkey_throw_items(number, map, items)
	end

	def execute_all_monkeys(map) do
		map = execute_one_monkey(0, map)
		map = execute_one_monkey(1, map)
		map = execute_one_monkey(2, map)
		map = execute_one_monkey(3, map)
		map = execute_one_monkey(4, map)
		map = execute_one_monkey(5, map)
		map = execute_one_monkey(6, map)
		map = execute_one_monkey(7, map)
	end

	def allrounds(rounds, map) when rounds > 0 do
		map = execute_all_monkeys(map)
		allrounds(rounds-1, map)
	end

	def allrounds(rounds, map) do map end

	def monkey_throw_items(_, map, []) do map end
	def monkey_throw_items(monkey, map, [item|rest]) do
		{:ok, div} = Map.fetch(map, {monkey, :div})
		{:ok, true_monkey} = Map.fetch(map, {monkey, :true})
		{:ok, false_monkey} = Map.fetch(map, {monkey, :false})

		map = cond do
			rem(item, div) == 0 -> 
				{:ok, true_items} = Map.fetch(map, {true_monkey, :items})
				true_items = [item|true_items]
				Map.put(map, {true_monkey, :items}, true_items)
			true -> 
				{:ok, false_items} = Map.fetch(map, {false_monkey, :items})
				false_items = [item|false_items]
				Map.put(map, {false_monkey, :items}, false_items)
		end
		monkey_throw_items(monkey, map, rest)
	end


	def parse_block([], map) do map end
	def parse_block([content|rest], map) do
		[row1, row2, row3, row4, row5, row6] = String.split(content, "\r\n")

		#Row 1, monkey 
		[monkey] = getNumbers(row1)
		monkey = String.to_integer(monkey)

		#Row 2, starting items
		list = getNumbers(row2) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :items}, list)

		#Row 4, divisible by number
		[div] = getNumbers(row4) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :div}, div)

		#Row 5, if true, throw to monkey
		[true_monkey] = getNumbers(row5) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :true}, true_monkey)

		#Row 6, if false, throw to monkey
		[false_monkey] = getNumbers(row6) |> Enum.map(fn(x) -> String.to_integer(x) end)
		map = Map.put(map, {monkey, :false}, false_monkey)

		#Create 0 inspections
		map = Map.put(map, {monkey, :inspections}, 0)

		#Recursion
		parse_block(rest, map)
	end

	def getNumbers(string) do
		Regex.scan(~r/\d+/, string) |> List.flatten
	end

end