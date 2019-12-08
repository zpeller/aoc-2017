#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_i)[0].freeze

LAST_ELEMENT = 2017

print(input, "\n")

def get_past_last_element(steps, last_element)
	spinlock = [0]
	(1..last_element).each { |n|
		print n, "\n" if n%10000 == 0
		spinlock.rotate!(steps+1)
		spinlock.unshift(n)
#		print n, ":", spinlock, "\n"
	}
	i0 = spinlock.index(0)
	return [spinlock[1], spinlock[i0+1]]	# don't care about last element...
end

def get_past_0(steps, last_element)
	pos0 = 0
	act_past_0 = 0
	(1..last_element).each { |n|
		pos0 -= steps+1
		while pos0 < 0 
			pos0 += n
		end
		pos0 += 1
		act_past_0 = n if pos0 == n
#		print n, ":", pos0, ":", act_past_0 ,"\n"
	}
	return act_past_0
end

print("P1 element past last after 2017: #{get_past_last_element(input, 2017)[0]}\n")
print("P2 element past 0 after 50million: #{get_past_0(input, 50000000)}\n")

__END__
371
