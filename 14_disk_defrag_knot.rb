#!/usr/bin/ruby

require 'set'

LIST_LEN = 256
KNOT_EXT = "17, 31, 73, 47, 23"

MAP_WIDTH = 128
MAP_HEIGHT = 128

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:strip)[0].freeze

def dense_hash(list)
	hash = list.each_slice(16).map { |x| x.inject(0) { |s, n| s^n } }
	return hash.inject("") { |s, c| s + ("%02x" % c) }
end

def knot_hash(input)
	list = (0..LIST_LEN-1).to_a
	ext_len = KNOT_EXT.scan(/\d+/).map(&:to_i)
	lengths = input.chars.map{|c| c.ord} + ext_len

	pos = 0
	skip_size = 0
	64.times {
		list, pos, skip_size = create_hash(list, pos, skip_size, lengths)
	}
	list += list.shift(LIST_LEN-(pos%LIST_LEN))

	return dense_hash(list)
end

def create_hash(list, pos, skip_size, lengths)
	lengths.each { |len|
		list += list.shift(len).reverse 
		list += list.shift(skip_size)
		pos += len + skip_size
		skip_size += 1
		skip_size = skip_size%LIST_LEN
	}
	return list, pos, skip_size
end

def disk_map_and_usage(key)
	rowcnt = 0
	map = []
	(0..127).each {|row|
		hash = knot_hash("#{key}-#{row}")
#		print row, ":", hash, "\n"
		row = hash.chars.map { |c| "%04b" % c.hex.to_i }.join('')
		rowcnt += row.count('1')
		map << row.chars.map(&:to_i)
	}
	return map, rowcnt
end

def adjacent_field_coords(x, y, w, h)
    field_coords = []
    if x < w-1
        field_coords << [x+1, y]
    end
    if y < h-1
        field_coords << [x, y+1]
    end
    if x>0
        field_coords << [x-1, y]
    end
    if y>0
        field_coords << [x, y-1]
    end
    return field_coords
end

def fill_region(disk_map, start_x, start_y, region_num)
    disk_map[start_y][start_x] = region_num

    step_list = Set.new
    step_list.add([start_x, start_y])

    while not step_list.empty?
        next_step_list = Set.new
        step_list.each {|c_x, c_y|
            adjacent_field_coords(c_x, c_y, MAP_WIDTH, MAP_HEIGHT).each { |x, y|
                if disk_map[y][x] != 0 and disk_map[y][x] != region_num
                    disk_map[y][x] = region_num
                    next_step_list.add?([x, y])
                end
            }
        }
        step_list = next_step_list
    end
end

def count_disk_regions(disk_map)
	region_num = 100
	(0..127).each { |x|
		(0..127).each { |y|
			if disk_map[y][x] == 1
				fill_region(disk_map, x, y, region_num)
				region_num += 1
			end
		}
	}
#	disk_map.each {|l| print l.join(' '), "\n"}
	disk_map.flatten.group_by{|x| x}.keys.length-1
end

disk_map, rowcnt = disk_map_and_usage(input)
print("P1 disk usage: #{rowcnt}\n")
print("P2 number of distinct disk regions: #{count_disk_regions(disk_map)}\n")



#disk_map.each {|row| print row.join(''), "\n" }

__END__
stpzcrnm
