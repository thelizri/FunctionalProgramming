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

end