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
	attr_reader :mul_run

	def initialize(program_code, rega)
		@program_code = program_code
		@program_id = rega

		@regs = Hash.new(0)
		@regs["a"] = rega

		@instr_ptr = 0
		@cnt = -1
		@terminated = false
		@mul_run = 0
	end

	def reg_or_value(regs, arg)
		if ("a".."z").include?(arg)
			regs[arg]
		else
			arg.to_i
		end
	end

	def get_regh
		return regs['h']
	end

	def run_program
		start_cnt = @cnt + 1
		while @instr_ptr>=0 and @instr_ptr<@program_code.length
			instr = @program_code[@instr_ptr][0]
			arg1 = @program_code[@instr_ptr][1]
			@cnt += 1
		print("#{@cnt} #{@instr_ptr} i: #{instr} a1: #{arg1} #{@regs}\n") if @cnt%10000000 == 0 
#		print("#{@cnt} #{@instr_ptr} i: #{instr} a1: #{arg1} #{@regs}\n")

			case instr
			when 'set'
				@regs[arg1] = reg_or_value(@regs, @program_code[@instr_ptr][2])
			when 'sub'
				@regs[arg1] -= reg_or_value(@regs, @program_code[@instr_ptr][2])
			when 'mul'
				@regs[arg1] *= reg_or_value(@regs, @program_code[@instr_ptr][2])
				@mul_run += 1
			when 'jnz'
				arg1_val = reg_or_value(@regs, arg1)
				if arg1_val != 0
					arg2 = @program_code[@instr_ptr][2]
					@instr_ptr += reg_or_value(@regs, arg2)
					next
				end
			end
			@instr_ptr += 1
		end
	end

end

def run_program(input, rega)
	return program_0.mul_run
end

program_0 = Program.new(input, 0)
program_0.run_program
print("P1 mul run times (a:0): #{program_0.mul_run}\n")

program_1 = Program.new(input, 1)
program_1.run_program
print("P2 mul run times (a:1): #{program_1.get_regh}\n")


__END__
set b 65
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23
