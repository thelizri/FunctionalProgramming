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

	def frequency(text) do
		Enum.reduce(text, Map.new(), fn(char, acc)-> Map.update(acc, char, 1, fn existing_value -> existing_value + 1 end) end)
	end

	# create a Huffman tree given a sample text
	def tree(text) do
		freq = frequency(text)
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

	# This is the benchmark of the single operations in the
	# Huffman encoding and decoding process.

	def bench(n) do
		{text, b} = read("lib/Assignments/Huffman/kallocain.txt", n)
		c = length(text)
		{tree, t2} = time(fn -> tree(text) end)
		{encode, t3} = time(fn -> encode_tree(tree) end)
		s = map_size(encode)
		{decode, _} = time(fn -> decode_table(encode) end)
		{encoded, t5} = time(fn -> encode(text, encode) end)
		e = div(length(encoded), 8)
		r = Float.round(e / b, 3)
		{_, t6} = time(fn -> decode(encoded, decode) end)

		IO.puts("text of #{c} characters")
		IO.puts("tree built in #{t2} ms")
		IO.puts("table of size #{s} in #{t3} ms")
		IO.puts("encoded in #{t5} ms")
		IO.puts("decoded in #{t6} ms")
		IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
	end

	# Measure the execution time of a function.
	def time(func) do
		initial = Time.utc_now()
		result = func.()
		final = Time.utc_now()
		{result, Time.diff(final, initial, :microsecond) / 1000}
	end

	# Get a suitable chunk of text to encode.
	def read(file, n) do
		{:ok, fd} = File.open(file, [:read, :utf8])
		binary = IO.read(fd, n)
		File.close(fd)

		length = byte_size(binary)
		case :unicode.characters_to_list(binary, :utf8) do
		  {:incomplete, chars, rest} ->
		    {chars, length - byte_size(rest)}
		  chars ->
		    {chars, length}
		end
	end

end