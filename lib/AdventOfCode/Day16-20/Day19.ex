defmodule Day19 do

	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day16-20/Day19.txt")
		String.split(content, "\r\n\r\n", trim: true)
		|> Enum.map(fn(x)-> String.split(x, "\r\n", trim: true) end)
		|> List.flatten()
	end
	def parse(list, result \\ [])
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
		parse(rest, [map]++result)
	end

	def main() do
		[head|rest]=read() |> parse()
		run(head)
	end

	def run(blueprint, robots \\ [ore: 1, clay: 0, obsidian: 0, geode: 0], rocks \\ [ore: 0, clay: 0, obsidian: 0, geode: 0], minutes \\ 1)
	def run(blueprint, robots, rocks, minutes) when minutes < 25 do
		#Produce new robots
		makeRobots(blueprint, robots, rocks)
		|> Enum.map(fn({robot, rock}) -> {robot, produceRocks(robots, rock)} end)
		|> Enum.map(fn({robot, rock}) -> run(blueprint, robot, rock, minutes+1) end)
		|> Enum.max()
	end
	def run(blueprint, robots, rocks, minutes) do 
		blueprint[:id]*rocks[:geode]
	end

	def produceRocks(robots, rocks) do
		Enum.reduce(robots, [], fn({id, num}, acc)-> 
		acc++[{id, num+rocks[id]}] end)
	end

	def makeRobots(blueprint, robots, rocks) do
		[oreRobot(blueprint, robots, rocks), 
		clayRobot(blueprint, robots, rocks),
		obsidianRobot(blueprint, robots, rocks),
		geodeRobot(blueprint, robots, rocks), 
		{robots, rocks}]
		|> Enum.filter(fn({robot, rock})-> robot != nil end)
		#Alternative 1, we build an ore robot
		#Alternative 2, we build a clay robot
		#Alternative 3, we build an obsidian robot
		#Alternative 4, we build a geode robot
		#Alternative 5, we don't build anything
	end

	def oreRobot(blueprint, robots, rocks) do
		cost = blueprint[:oreRobot]
		money = rocks[:ore]
		if cost <= money do
			robots = Enum.map(robots, fn({id, num})-> if id == :ore do {id, num+1} else {id, num} end end)
			rocks = Enum.map(rocks, fn({id, num})-> if id == :ore do {id, num-cost} else {id, num} end end)
			{robots, rocks}
		else 
			{nil, rocks}
		end
	end

	def clayRobot(blueprint, robots, rocks) do
		cost = blueprint[:clayRobot]
		money = rocks[:ore]
		if cost <= money do
			robots = Enum.map(robots, fn({id, num})-> if id == :clay do {id, num+1} else {id, num} end end)
			rocks = Enum.map(rocks, fn({id, num})-> if id == :clay do {id, num-cost} else {id, num} end end)
			{robots, rocks}
		else
			{nil, rocks}
		end
	end

	def obsidianRobot(blueprint, robots, rocks) do
		cost = blueprint[:obsidianRobot]
		ore = cost[:ore]
		clay = cost[:clay]
		myOre = rocks[:ore]
		myClay = rocks[:clay]
		if ore <= myOre and clay <= myClay do
			robots = Enum.map(robots, fn({id, num})-> if id == :obsidian do {id, num+1} else {id, num} end end)
			rocks = Enum.map(rocks, fn({id, num})-> case id do :ore -> {id, num-ore}; :clay -> {id, num-clay}; 
				_ -> {id, num}; end end)
			{robots, rocks}
		else
			{nil, rocks}
		end
	end

	def geodeRobot(blueprint, robots, rocks) do
		cost = blueprint[:geodeRobot]
		ore = cost[:ore]
		obsidian = cost[:obsidian]
		myOre = rocks[:ore]
		myObsidian = rocks[:obsidian]
		if ore <= myOre and obsidian <= myObsidian do
			robots = Enum.map(robots, fn({id, num})-> if id == :geode do {id, num+1} else {id, num} end end)
			rocks = Enum.map(rocks, fn({id, num})-> case id do :ore -> {id, num-ore}; :obsidian -> {id, num-obsidian}; 
				_ -> {id, num}; end end)
			{robots, rocks}
		else
			{nil, rocks}
		end
	end




end