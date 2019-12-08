#!/usr/bin/ruby

require 'set'

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	l.scan(/-?\d+/).map(&:to_i)
}[0].freeze

# print(input, "\n")

def num_before_seen_again(init_membanks)
	membanks = Marshal.load(Marshal.dump(init_membanks))

	states_seen = Hash.new
	cycles = 0
	loop_len = 0
	loop do
		cycles += 1
		max_num = membanks.max
		max_idx = membanks.index(max_num)
		membanks[max_idx] = 0
		idx = max_idx + 1
		while max_num > 0
			idx = 0 if idx > membanks.length-1
			membanks[idx] += 1
			idx += 1
			max_num -= 1
		end
		new_state = membanks.hash
		if states_seen.key?(new_state)
			loop_len = cycles - states_seen[new_state]
			break
		end
		states_seen[new_state] = cycles
	end
	return cycles, loop_len
end

c, l = num_before_seen_again(input)
print("P1 num distrib cycles without repeat: #{c}\n")
print("P2 repeated loop length: #{l}\n")

__END__
11	11	13	7	0	15	5	5	4	4	1	1	7	1	15	11
