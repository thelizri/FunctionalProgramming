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

end