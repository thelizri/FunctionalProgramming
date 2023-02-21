defmodule Day9 do

	def add(set, tailPosition) do MapSet.put(set, tailPosition) end

	def size(set) do MapSet.size(set) end

	def getDistance({headX, headY}, {tailX, tailY}) do
		x = (headX-tailX)*(headX-tailX); y = (headY-tailY)*(headY-tailY)
		dis = :math.sqrt(x+y)
		cond do dis > 1.5 -> true; true -> false; end
	end

	def getNewTailPosition(head={headX, headY}, tail={tailX, tailY}) do
		cond do
			getDistance(head, tail) ->
				case {headX-tailX, headY-tailY} do
					{0,_} -> moveVertical(head, tail)
					{_,0} -> moveHorizontal(head, tail)
					_ -> moveDiagonal(head, tail)
				end
			true -> tail
		end
	end

	def moveVertical({headX, headY}, {tailX, tailY}) do cond do headY > tailY -> {tailX, tailY+1}; true -> {tailX, tailY-1} end end
	def moveHorizontal({headX, headY}, {tailX, tailY}) do cond do headX > tailX -> {tailX+1, tailY}; true -> {tailX-1, tailY} end end

	def moveDiagonal(head={headX, headY}, tail={tailX, tailY}) do
		{_, tailY} = moveVertical(head, tail)
		{tailX, _} = moveHorizontal(head, tail)
		{tailX, tailY}
	end

	def read() do
		{:ok, input} = File.read("lib/AdventOfCode/Day9.txt")
		content = String.split(input, "\r\n")
		for row <- content do
			[direction, steps] = String.split(row, " ", trim: true)
			{direction, String.to_integer(steps)}
		end |> execute_program(add(MapSet.new(), {0,0}), {0,0}, {0,0})
	end

	def execute_program([], set, head, tail) do
		size(set)
	end

	def execute_program([row={direction, steps}|rest], set, head, tail) do
		{set, head, tail} = move(direction, steps, set, head, tail)
		execute_program(rest, set, head, tail)
	end

	def move(_, 0, set, head, tail) do
		{set, head, tail}
	end

	def move(direction, steps, set, head={headX, headY}, tail={tailX, tailY}) do
		head = case direction do
			"R" -> {headX+1, headY}
			"U" -> {headX, headY+1}
			"D" -> {headX, headY-1}
			"L" -> {headX-1, headY}
		end
		tail = getNewTailPosition(head, tail)
		set = add(set, tail)
		move(direction, steps-1, set, head, tail)
	end

	#######################################################################################################################################
	# Part 2

	def getUpdateTailList(tail, [], list) do
		{tail, list}
	end

	def getUpdateTailList(head, [tail|rest], result) do
		tail = getNewTailPosition(head, tail)
		new = result ++ [tail]
		getUpdateTailList(tail, rest, new)
	end
	
	def create_list() do
		for n <- 1..9 do {0,0} end
	end

	def move_part_2(_, 0, set, head, tailList) do
		{set, head, tailList}
	end

	def move_part_2(direction, steps, set, head={headX, headY}, tailList) do
		head = case direction do
			"R" -> {headX+1, headY}
			"U" -> {headX, headY+1}
			"D" -> {headX, headY-1}
			"L" -> {headX-1, headY}
		end
		{tail, tailList} = getUpdateTailList(head, tailList, [])
		set = add(set, tail)
		move_part_2(direction, steps-1, set, head, tailList)
	end

	def execute_program_part_2([], set, head, tailList) do
		size(set)
	end

	def execute_program_part_2([row={direction, steps}|rest], set, head, tailList) do
		{set, head, tailList} = move_part_2(direction, steps, set, head, tailList)
		execute_program_part_2(rest, set, head, tailList)
	end

	def read_part_2() do
		{:ok, input} = File.read("lib/AdventOfCode/Day9.txt")
		content = String.split(input, "\r\n")
		instructions = for row <- content do
			[direction, steps] = String.split(row, " ", trim: true)
			{direction, String.to_integer(steps)}
		end
		execute_program_part_2(instructions, add(MapSet.new(), {0,0}), {0,0}, create_list())
	end

end