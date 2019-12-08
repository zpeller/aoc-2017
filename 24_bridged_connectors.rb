#!/usr/bin/ruby

require 'pp'

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	l.scan(/-?\d+/).map(&:to_i).sort
}.freeze

def init_components(components, comp_list)
	comp_list.sort.each { |a, b|
		components[a] += [[a, b]]
		components[b] += [[a, b]] if a != b
	}
end

def add_component_to_bridge(components, connector, prev_components, new_component)
	components = Marshal.load(Marshal.dump(components))
	if new_component[0] == new_component[1]
		next_connector = connector
	else
		next_connector = (new_component - [connector])[0]
		components[next_connector].delete(new_component)
	end
	components[connector].delete(new_component)
	find_component_for_connector(components, next_connector, prev_components + [new_component])
end

def find_component_for_connector(components, connector, prev_components)
	if components[connector].empty?

		act_strength = prev_components.flatten.inject(:+)
#		pms = $max_strength
		$max_strength = [$max_strength, [act_strength, prev_components] ].max

#		pml = $max_length
		$max_length = [$max_length, [prev_components.length, act_strength, prev_components] ].max

#		print $max_strength, "\n\n" if pms != $max_strength
#		print $max_length, "\n\n" if pml != $max_length
		return
	end
	components[connector].each { |new_component|
		add_component_to_bridge(components, connector, prev_components, new_component)
	}
end

def find_strongest_and_longest_bridge(components)
	find_component_for_connector(components, 0, [])
end

$max_strength = [0, []]
$max_length = [0, 0, []]
components = Hash.new([])
init_components(components, input)
#pp components

find_strongest_and_longest_bridge(components)
print("P1 strongest bridge: #{$max_strength}\n")
print("P2 longest bridge: #{$max_length}\n")

__END__
32/31
2/2
0/43
45/15
33/24
20/20
14/42
2/35
50/27
2/17
5/45
3/14
26/1
33/38
29/6
50/32
9/48
36/34
33/50
37/35
12/12
26/13
19/4
5/5
14/46
17/29
45/43
5/0
18/18
41/22
50/3
4/4
17/1
40/7
19/0
33/7
22/48
9/14
50/43
26/29
19/33
46/31
3/16
29/46
16/0
34/17
31/7
5/27
7/4
49/49
14/21
50/9
14/44
29/29
13/38
31/11
