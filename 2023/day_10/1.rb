# frozen_string_literal: true

require './map'
require './tile'
require './cursor'

map = Map.new(File.read(ARGV[0] || 'test_input_1.txt'))

starting_cursor = Cursor.new(map, *map.starting_point)
starting_cursor.detect_tile_type!

cursors = starting_cursor.possible_directions.map { starting_cursor.go_to(_1) }
counter = 1

until cursors.first == cursors.last
  cursors.map! do |cursor|
    direction = (cursor.possible_directions - [cursor.came_from]).first
    cursor.go_to(direction)
  end

  counter += 1
end

puts counter
