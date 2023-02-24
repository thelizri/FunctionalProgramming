defmodule Day19 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day16-20/Day19.txt")
		String.split(content, "\r\n\r\n", trim: true)
		|> Enum.map(fn(x)-> String.split(x, "\r\n", trim: true) end)
		|> List.flatten()
	end

	def parse([], result) do result end
	def parse([a, b, c, d, e|rest], result) do
		map = Map.new()

		[[num]] = Regex.scan(~r/\d+/, a)
		blueprint_id = String.to_integer(num) 
		map = Map.put(map, :id, blueprint_id)

		[[num]] = Regex.scan(~r/\d+/, b)
		ore_robot_cost = String.to_integer(num)
		map = Map.put(map, :oreRobot, ore_robot_cost)

		[[num]] = Regex.scan(~r/\d+/, c)
		clay_robot_cost = String.to_integer(num) 
		map = Map.put(map, :clayRobot, clay_robot_cost)

		[[ore], [clay]] = Regex.scan(~r/\d+/, d)
		ore = String.to_integer(ore)
		clay = String.to_integer(clay)
		map = Map.put(map, :obsidianRobot, [ore: ore, clay: clay])

		[[ore], [obsidian]] = Regex.scan(~r/\d+/, e)
		ore = String.to_integer(ore)
		obsidian = String.to_integer(obsidian)
		map = Map.put(map, :geodeRobot, [ore: ore, obsidian: obsidian])
		parse(rest, Map.put(result, blueprint_id, map))
	end

	def main() do
		read() |> parse(Map.new())
	end

end