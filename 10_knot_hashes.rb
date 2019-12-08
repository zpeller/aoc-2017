#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	nums = l.scan(/-?\d+/).map(&:to_i)
	[nums, l.strip]
}[0].freeze

def hash_mul(lengths)
	list = (0..LIST_LEN-1).to_a
	hash, pos, skip_size = create_hash(list, 0, 0, lengths)
	hash += hash.shift(LIST_LEN-(pos%LIST_LEN))
	return hash[0]*hash[1]
end

def dense_hash(list)
	hash = list.each_slice(16).map { |x| x.inject(0) { |s, n| s^n } }
	return hash.inject("") { |s, c| s + ("%02x" % c) }
end

def hash_string(input, ext_len_s)
	list = (0..LIST_LEN-1).to_a
	ext_len = ext_len_s.scan(/\d+/).map(&:to_i)
	lengths = input.chars.map{|c| c.ord} + ext_len

	pos = 0
	skip_size = 0
	64.times {
		list, pos, skip_size = create_hash(list, pos, skip_size, lengths)
	}
	list += list.shift(LIST_LEN-(pos%LIST_LEN))

	return dense_hash(list)
end

def create_hash(list, pos, skip_size, lengths)
	lengths.each { |len|
		list += list.shift(len).reverse 
		list += list.shift(skip_size)
		pos += len + skip_size
		skip_size += 1
		skip_size = skip_size%LIST_LEN
	}
	return list, pos, skip_size
end

LIST_LEN=256

print("P1 l0*l1 = #{hash_mul(input[0])}\n")
print("P2 hash string: #{hash_string(input[1], "17, 31, 73, 47, 23")}\n")

__END__
197,97,204,108,1,29,5,71,0,50,2,255,248,78,254,63
