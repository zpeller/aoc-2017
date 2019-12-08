#!/usr/bin/ruby

require 'pp'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:strip).freeze

#input.each {|l|
#	print(l, "\n")
#}

def init_grid(grid, grid_input)
	grid_input.each_with_index { |line, y|
		line.chars.each_with_index { |c, x|
			grid[[x,y]] = c
		}
	}
end

def turn(v, turn)
	return [ -v[0], -v[1] ] if turn == 'B'

	v_x, v_y = 0, 0
	if v[0] == 0
		v_x = ((v[1]==-1 and turn=='R') or (v[1]==1 and turn=='L')) ? 1 : -1
	else
		v_y = ((v[0]==-1 and turn=='R') or (v[0]==1 and turn=='L')) ? -1 : 1
	end
	return [v_x, v_y]
end

def count_bursts_of_infections(grid, start_pos, start_v, iterations, advanced=false)
	infects = 0
	pos = start_pos.dup
	v = start_v
	iterations.times {
		case grid[pos]
		when '#'
			grid[pos] = advanced ? 'F' : '.'
			v = turn(v, 'R')
		when '.'
			if advanced
				grid[pos] = 'W'
			else
				grid[pos] = '#'
				infects += 1
			end
			v = turn(v, 'L')
		when 'W'
			grid[pos] = '#'
			infects += 1
		when 'F'
			grid[pos] = '.'
			v = turn(v, 'B')
		end
		pos[0] += v[0]
		pos[1] += v[1]
	}
	return infects
end

start_pos = [ input[0].length/2, input.length/2 ].freeze

grid = Hash.new('.')
init_grid(grid, input)
print("P1 no of infections: #{count_bursts_of_infections(grid, start_pos, [0, -1], 10000)}\n")

grid = Hash.new('.')
init_grid(grid, input)
print("P2 no of infections: #{count_bursts_of_infections(grid, start_pos, [0, -1], 10000000, true)}\n")

#pp grid, start_pos


__END__
.......##.#..####.#....##
..###....###.####..##.##.
#..####.#....#.#....##...
.#....#.#.#....#######...
.###..###.#########....##
##...#####..#####.###.#..
.#..##.###.#.#....######.
.#.##.#..####..#.##.....#
#.#..###..##..#......##.#
##.###.##.#.#...##.#.##..
##...#.######.#..##.#...#
....#.####..#..###.##..##
...#....#.###.#.#..#.....
..###.#.#....#.....#.####
.#....##..##.#.#...#.#.#.
...##.#.####.###.##...#.#
##.#.####.#######.##..##.
.##...#......####..####.#
#..###.#.###.##.#.#.##..#
#..###.#.#.#.#.#....#.#.#
####.#..##..#.#..#..#.###
##.....#..#.#.#..#.####..
#####.....###.........#..
##...#...####..#####...##
.....##.#....##...#.....#
