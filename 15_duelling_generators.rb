#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	l.scan(/-?\d+/).map(&:to_i)[0]
}.freeze

print(input, "\n")

FACTOR_GEN_A = 16807
FACTOR_GEN_B = 48271
DIVISOR = 2147483647

def gen_next_value(prev, factor, mul_check)
	if mul_check == 0
		return (prev*factor) % DIVISOR
	end
	loop do
		prev = (prev*factor) % DIVISOR
		break if prev % mul_check == 0
	end
	return prev
end

def count_matching_pairs(genA_start, genA_factor, genB_start, genB_factor, cycles, need_mul_check)
	genA_val = genA_start
	genB_val = genB_start
	match_cnt = 0
	cycles.times {
		genA_val = gen_next_value(genA_val, genA_factor, need_mul_check ? 4 : 0)
		genB_val = gen_next_value(genB_val, genB_factor, need_mul_check ? 8 : 0)
		match_cnt += 1 if genA_val % (2**16) == genB_val % (2**16)
	}
	return match_cnt
end

print("P1 matching pairs after 40m: #{count_matching_pairs(input[0], FACTOR_GEN_A, input[1], FACTOR_GEN_B, 40000000, false)}\n")
print("P2 matching special pairs after 5m: #{count_matching_pairs(input[0], FACTOR_GEN_A, input[1], FACTOR_GEN_B, 5000000, true)}\n")
	
__END__
Generator A starts with 679
Generator B starts with 771
