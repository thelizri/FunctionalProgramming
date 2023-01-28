defmodule Identicon do

	def main(input) do
		input
		|> hash_input
		|> pick_color
		|> build_grid
	end

	def hash_input(input) do
		:crypto.hash(:md5, input)
		|> :binary.bin_to_list
	end

	def pick_color([r,g,b|tail]) do
		{{r,g,b}, tail}
	end

	def build_grid({color, tail}) do
		tail = Enum.chunk_every(tail, 3, 3, :discard) 
		grid = for row <- tail do
			mirror_row(row)
		end
		{color, grid}
	end

	def mirror_row([a,b,c]) do [a,b,c,b,a] end

end