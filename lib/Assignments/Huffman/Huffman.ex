defmodule Huffman do

	def sample do
		'the quick brown fox jumps over the lazy dog
	    this is a sample text that we will use when we build
	    up a table we will only handle lower case letters and
	    no punctuation symbols the frequency will of course not
	    represent english but it is probably not that far off'
	end

	def text() do
		'this is something that we should encode world'
	end

	def test do
		sample = sample()
		tree = tree(sample)
		encode = encode_tree(tree)
	    decode = decode_table(encode)
	    text = text()
	    seq = encode(text, encode)
	    decode(seq, decode) |> to_string()
	end

	def frequency(text) do frequency(text, Map.new()) end
	def frequency([], map) do map end
	def frequency([head|rest], map) do
		map = Map.update(map, head, 1, fn existing_value -> existing_value + 1 end)
		frequency(rest, map)
	end

	# create a Huffman tree given a sample text
	def tree(sample) do
		freq = frequency(sample)
		|> Map.to_list()
		|> Enum.sort(fn({_, f1}, {_, f2})-> f1 <= f2 end)
		|> huffman_tree()
	end

	def huffman_tree([{tree, _}]), do: tree
	def huffman_tree([{a, af}, {b, bf} | rest]) do
	huffman_tree(insert({{a, b}, af + bf}, rest))
	end

	#Inserts it in the proper position
	def insert({a, af}, []), do: [{a, af}]
	def insert({a, af}, [{b, bf} | rest]) when af < bf do
	[{a, af}, {b, bf} | rest]
	end
	def insert({a, af}, [{b, bf} | rest]) do
	[{b, bf} | insert({a, af}, rest)]
	end

	#Encode the tree to a table
	def encode_tree(tree) do
		encode_tree(tree, Map.new(), [])
	end
	def encode_tree({left, right}, table, code) do
		table = encode_tree(left, table, [0|code])
		encode_tree(right, table, [1|code])
	end
	def encode_tree(char, table, code) do
		Map.put(table, char, Enum.reverse(code))
	end

	#Take our previous map and reverse it
	def decode_table(map) do
		Map.to_list(map)
		|> Enum.reduce(Map.new(), fn({key, value}, acc)-> Map.put(acc, value, key) end)
	end

	#Encode our text
	def encode(text, table) do#
		Enum.map(text, fn(x)-> Map.get(table, x) end)
		|> List.flatten()
	end

	#Decode our list to text
	def decode(list, table) do
		decode(list, table, '', '')
		|> Enum.reverse()
	end

	def decode([], table, result, key) do result end
	def decode([head|rest], table, result, key) do
		key = key ++ [head]
		temp = Map.get(table, key)
		if temp != nil do
			decode(rest, table, [temp]++result, '')
		else 
			decode(rest, table, result, key)
		end
	end

	#def decode(list, table) do
	#	Enum.reverse(list)
	#	|> decode(table, '', '')
	#end

	#def decode([], table, result, key) do result end
	#def decode([head|rest], table, result, key) do
	#	key = [hea#d|key]
	#	temp = Map.get(table, key)
	#	if temp != nil do
	#		decode(rest, table, [temp|result], '')
	#	else
	#		decode(rest, table, result, key)
	#	end
	#end

end