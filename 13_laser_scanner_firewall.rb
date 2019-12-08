#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	nums = l.scan(/-?\d+/).map(&:to_i)
	nums
}.freeze

#print(input, "\n")

#input.each {|l|
#	print(l, "\n")
#}
class Layer
	def initialize(depth, range)
		@depth = depth
		@range = range
		@pos = 0
		@dir = 1
		@severity = @depth * @range
		@period = 2*(range-1)
	end

	def get_severity(pos, min_1)
		if min_1
			pos == @pos ? ([@severity, 1].max) : 0
		else
			pos == @pos ? @severity : 0
		end
	end

	def set_delay(delay)
		delay = delay % @period
		if delay < @range
			@pos = delay
		else
			@pos = @period - delay
		end
		@dir = (delay < @range-1) ? 1 : -1
	end

	def inspect
		"#{@pos}:#{@dir?'+':'-'}:#{@range}"
	end
end

def init_layers(layers, layer_input)
	layer_input.each {|d, r|
		layers[d] = Layer.new(d, r)
	}
end

def severity_of_ride(layers, first_only, severity_min_1, delay)
	all_severity = 0
	layers.each {|depth, layer|
#		print depth, ":", layers, "\n"
		layer.set_delay(delay+depth)
		all_severity += layers[depth].get_severity(0, severity_min_1)
		return all_severity if first_only and all_severity>0
	}
	return all_severity
end

def first_zero_severity_ride(layers)
	0.step { |delay|
#		print delay, "\n" if delay % 100000 == 0
		sr = severity_of_ride(layers, true, true, delay)
		return delay if sr == 0
	}
end

layers = {}
init_layers(layers, input)
print("P1 severity of ride: #{severity_of_ride(layers, false, false, 0)}\n")
print("P2 delay for 0 severity ride: #{first_zero_severity_ride(layers)}\n")


__END__
0: 3
1: 2
2: 4
4: 6
6: 4
8: 6
10: 5
12: 8
14: 8
16: 6
18: 8
20: 6
22: 10
24: 8
26: 12
28: 12
30: 8
32: 12
34: 8
36: 14
38: 12
40: 18
42: 12
44: 12
46: 9
48: 14
50: 18
52: 10
54: 14
56: 12
58: 12
60: 14
64: 14
68: 12
70: 17
72: 14
74: 12
76: 14
78: 14
82: 14
84: 14
94: 14
96: 14
