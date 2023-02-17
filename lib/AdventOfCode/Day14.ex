defmodule Day14 do
	def read() do
		{:ok, content} = File.read("lib/AdventOfCode/Day14.txt")
		content = String.split("\r\n", trim: true)
	end

end