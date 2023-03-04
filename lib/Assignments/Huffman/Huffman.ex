defmodule Huffman do

	def sample do
		'the quick brown fox jumps over the lazy dog
		this is a sample text that we will use when we build
		up a table we will only handle lower case letters and
		no punctuation symbols the frequency will of course not
		represent english but it is probably not that far off'
	end

	def text() do
		'this is something that we should encode'
	end

	def test do
		sample = sample()
		tree = tree(sample)
		encode = encode_table(tree)
		decode = decode_table(tree)
		text = text()
		seq = encode(text, encode)
		decode(seq, decode)
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
	end

	def huffman() do

	end

	# create an encoding table containing the mapping from characters to codes given a Huffman tree
	def encode_table(tree) do
		# To implement...
	end

	# create an decoding table containing the mapping from codes to characters given a Huffman tree
	def decode_table(tree) do
		# To implement...
	end

	# encode the text using the mapping in the table, return a sequence of bits
	def encode(text, table) do
		# To implement...
	end

	# ecode the bit sequence using the mapping in table, return a text
	def decode(seq, tree) do
		# To implement...
	end

end