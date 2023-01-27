defmodule Day5 do

	def move(from, to, amount) do
		{cargo, from} = Enum.split(from, amount)
		cargo = Enum.reverse(cargo)
		to = cargo ++ to
		{from, to}
	end

end