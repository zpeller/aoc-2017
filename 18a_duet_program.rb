#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
#	l.scan(/-?\d+/).map(&:to_i).freeze
	if l =~ / .* /
		tokens = l.scan(/^(...) (.|-?\d+) (.|-?\d+)$/)[0].freeze
		[tokens[0], tokens[1], tokens[2]]
	else
		tokens = l.scan(/^(...) (.*)$/)[0].freeze
		[tokens[0], tokens[1]]
	end
}.freeze

#print(input, "\n")

#input.each {|l|
#	print(l, "\n")
#}

def reg_or_value(regs, arg)
	if ("a".."z").include?(arg)
		regs[arg]
	else
		arg.to_i
	end
end

def run_program(program, regp)
	instr_ptr = 0
	cnt = -1
	regs = Hash.new(0)
	regs["p"] = regp
	sound_freq = 0
	while instr_ptr>=0 and instr_ptr<program.length
		instr = program[instr_ptr][0]
		arg1 = program[instr_ptr][1]
		cnt += 1
#		print("#{cnt} #{instr_ptr} i: #{instr} a1: #{arg1} #{regs}\n") if cnt%10000000 == 0 
#		print("#{cnt} #{instr_ptr} i: #{instr} a1: #{arg1} #{regs}\n")

		case instr
		when 'set'
			regs[arg1] = reg_or_value(regs, program[instr_ptr][2])
		when 'add'
			regs[arg1] += reg_or_value(regs, program[instr_ptr][2])
		when 'mul'
			regs[arg1] *= reg_or_value(regs, program[instr_ptr][2])
		when 'mod'
			regs[arg1] %= reg_or_value(regs, program[instr_ptr][2])
		when 'snd'
			sound_freq = regs[arg1]
		when 'rcv'
			return sound_freq if reg_or_value(regs, arg1) != 0
		when 'jgz'
			arg1_val = reg_or_value(regs, arg1)
			if arg1_val > 0
				arg2 = program[instr_ptr][2]
				instr_ptr += reg_or_value(regs, arg2)
				next
			end
		end
		instr_ptr += 1
	end
	return 0
end


print("P1 recovered freq: " + run_program(input, 0).to_s + "\n")
#print("P2 reg a: " + run_program(input, 12).to_s + "\n")

__END__
set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 680
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19
