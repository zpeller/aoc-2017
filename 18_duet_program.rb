#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	if l =~ / .* /
		tokens = l.scan(/^(...) (.|-?\d+) (.|-?\d+)$/)[0].freeze
		[tokens[0], tokens[1], tokens[2]]
	else
		tokens = l.scan(/^(...) (.*)$/)[0].freeze
		[tokens[0], tokens[1]]
	end
}.freeze

class Program
	attr_reader :sent_cnt

	def initialize(program_code, regp)
		@program_code = program_code
		@program_id = regp

		@regs = Hash.new(0)
		@regs["p"] = regp

		@instr_ptr = 0
		@cnt = -1
		@peer_program = nil
		@receive_queue = []
		@sent_cnt = 0
		@terminated = false
	end

	def set_peer(peer_program)
		@peer_program = peer_program
	end

	def send_to_peer(value)
		@peer_program.receive(value)
		@sent_cnt += 1
	end

	def receive(value)
		@receive_queue << value
	end

	def reg_or_value(regs, arg)
		if ("a".."z").include?(arg)
			regs[arg]
		else
			arg.to_i
		end
	end

	def run_program(sound_mode=false)
		return -4 if @terminated
		return -3 if @peer_program == nil

		start_cnt = @cnt + 1
		while @instr_ptr>=0 and @instr_ptr<@program_code.length
			instr = @program_code[@instr_ptr][0]
			arg1 = @program_code[@instr_ptr][1]
			@cnt += 1
#		print("#{@cnt} #{@instr_ptr} i: #{instr} a1: #{arg1} #{@regs}\n") if @cnt%10000000 == 0 
#		print("#{@cnt} #{@instr_ptr} i: #{instr} a1: #{arg1} #{@regs}\n")

			case instr
			when 'set'
				@regs[arg1] = reg_or_value(@regs, @program_code[@instr_ptr][2])
			when 'add'
				@regs[arg1] += reg_or_value(@regs, @program_code[@instr_ptr][2])
			when 'mul'
				@regs[arg1] *= reg_or_value(@regs, @program_code[@instr_ptr][2])
			when 'mod'
				@regs[arg1] %= reg_or_value(@regs, @program_code[@instr_ptr][2])
			when 'snd'
				send_to_peer(reg_or_value(@regs, arg1))
			when 'rcv'
				if @receive_queue.length == 0
					return (start_cnt == @cnt ? -2 : -1)
				end
				if not sound_mode
					@regs[arg1] = @receive_queue.shift
				else
					if reg_or_value(@regs, arg1) != 0
						return @receive_queue.last
					end
				end
			when 'jgz'
				arg1_val = reg_or_value(@regs, arg1)
				if arg1_val > 0
					arg2 = @program_code[@instr_ptr][2]
					@instr_ptr += reg_or_value(@regs, arg2)
					next
				end
			end
			@instr_ptr += 1
		end
		@terminated = true
		return @sent_cnt
	end

end

def run_programs(input)
	program_0 = Program.new(input, 0)
	program_1 = Program.new(input, 1)
	program_0.set_peer(program_1)
	program_1.set_peer(program_0)
	rv0 = -1
	rv1 = -1
	while rv0<0 or rv1<0
		rv0 = program_0.run_program
		rv1 = program_1.run_program
		break if (rv0 == -2 and rv1 == -2) or (rv0 == -4 and rv1 == -4)
	end
	print "deadlock detected\n" if rv0 == -2 and rv1 == -2
	return program_1.sent_cnt
end

def run_soundcard(input)
	program_0 = Program.new(input, 0)
	program_0.set_peer(program_0)
	program_0.run_program(true)
end


print("P1 recovered freq: #{run_soundcard(input)}\n")
print("P2 num sends: #{run_programs(input)}\n")

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
