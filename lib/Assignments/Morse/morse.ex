defmodule Morse do

	def encode_table() do
		%{
			?a => '._',
			?b => '_...',
			?c => '_._.',
			?d => '_..',
			?e => '.',
			?f => '.._.',
			?g => '__.',
			?h => '....',
			?i => '..',
			?j => '.___',
			?k => '_._',
			?l => '._..',
			?m => '__',
			?n => '_.',
			?o => '___',
			?p => '.__.',
			?q => '__._',
			?r => '._.',
			?s => '...',
			?t => '_',
			?u => '.._',
			?v => '..._',
			?w => '.__',
			?x => '_.._',
			?y => '_.__',
			?z => '__..'
		}
	end

	def encode(text) do
		encode(text, encode_table(), [])
		|> Enum.reverse()
	end

	def encode([], table, acc) do acc end
	def encode([head|rest], table, acc) do
		char = Map.get(table, head)
		char = Enum.reverse(char)
		char = [32|char]
		acc = char++acc
		encode(rest, table, acc)
	end

	def decode_table() do
		{:node, :na,
		{:node, 116,
		{:node, 109,
		{:node, 111,
		{:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
		{:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
		{:node, 103,
		{:node, 113, nil, nil},
		{:node, 122,
		{:node, :na, {:node, 44, nil, nil}, nil},
		{:node, 55, nil, nil}}}},
		{:node, 110,
		{:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
		{:node, 100,
		{:node, 120, nil, nil},
		{:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
		{:node, 101,
		{:node, 97,
		{:node, 119,
		{:node, 106,
		{:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
		nil},
		{:node, 112,
		{:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
		nil}},
		{:node, 114,
		{:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
		{:node, 108, nil, nil}}},
		{:node, 105,
		{:node, 117,
		{:node, 32,
		{:node, 50, nil, nil},
		{:node, :na, nil, {:node, 63, nil, nil}}},
		{:node, 102, nil, nil}},
		{:node, 115,
		{:node, 118, {:node, 51, nil, nil}, nil},
		{:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
	end

	def decode(text) do
		decode(text, decode_table(), []) |>
		Enum.reverse()
	end

	def decode([], _, acc) do acc end
	def decode(text=[head|rest], {:node, v, left, right}, acc) do
		cond do
			head == 32 or head == 10 -> acc = [v|acc]
				decode(rest, decode_table(), acc)
			head == ?_ or head == ?- -> decode(rest, left, acc)
			head == ?. -> decode(rest, right, acc)
			true -> IO.puts("Error")
		end
	end

end