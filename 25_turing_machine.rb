#!/usr/bin/ruby

require 'pp'

#input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
#	tokens = l.strip.scan(/^(.*) to (.*) = (.*)$/)[0].freeze
#	[tokens[0], tokens[1]]
#}.freeze
#
#input.each {|l|
#	print(l, "\n")
#}

STATES = {
	'A'=> [[1, 1, 'B'], [0, -1, 'C']],
	'B'=> [[1, -1, 'A'], [1, 1, 'D']],
	'C'=> [[1, 1, 'A'], [0, -1, 'E']],
	'D'=> [[1, 1, 'A'], [0, 1, 'B']],
	'E'=> [[1, -1, 'F'], [1, -1, 'C']],
	'F'=> [[1, 1, 'D'], [1, 1, 'A']]
}

INIT_STATE = 'A'
STEPS = 12173597

def get_checksum_after_steps(steps, init_state)
	state = init_state
	pos = 0
	turing = Hash.new(0)
	steps.times {
		instr = STATES[state][turing[pos]]
		turing[pos] = instr[0]
		pos += instr[1]
		state = instr[2]
	}
	return turing.values.select{|x| x == 1}.length
end

print("P1 checksum after #{STEPS} steps: #{get_checksum_after_steps(STEPS, INIT_STATE)}\n")

__END__
Begin in state A.
Perform a diagnostic checksum after 12173597 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state C.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state D.

In state C:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state E.

In state D:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state B.

In state E:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state F.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state C.

In state F:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state D.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
