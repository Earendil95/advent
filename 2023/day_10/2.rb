# frozen_string_literal: true

require './map'
require './tile'
require './cursor'
require './inside_tile_counter'

map = Map.new(File.read(ARGV[0] || 'test_input_1.txt'))

starting_cursor = Cursor.new(map, *map.starting_point)
starting_cursor.detect_tile_type!

cursors = starting_cursor.possible_directions.map { starting_cursor.go_to(_1) }
border = [[starting_cursor.line_no, starting_cursor.column_no]].to_set

until cursors.first == cursors.last
  border += cursors.map { [_1.line_no, _1.column_no] }

  cursors.map!.with_index do |cursor, i|
    direction = (cursor.possible_directions - [cursor.came_from]).first
    cursor.go_to(direction)
  end
end

border << [cursors.first.line_no, cursors.first.column_no]

count = InsideTileCounter.new(map, border).count

puts count
