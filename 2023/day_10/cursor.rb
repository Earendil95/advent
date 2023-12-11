# frozen_string_literal: true

# :nodoc:
class Cursor
  ALL_DIRECTIONS = %i[north east west south].freeze

  DIRECTION_TO_NUMBERS = {
    north: [-1, 0],
    south: [1, 0],
    west: [0, -1],
    east: [0, 1]
  }.freeze

  POSSIBLE_DIRECTIONS = {
    '|' => %i[north south],
    '-' => %i[east west],
    'L' => %i[north east],
    'J' => %i[north west],
    '7' => %i[west south],
    'F' => %i[east south]
  }.freeze

  attr_reader :map, :line_no, :column_no, :came_from

  def initialize(map, line_no, column_no, came_from = nil)
    @map = map
    @line_no = line_no
    @column_no = column_no
    @came_from = came_from
  end

  def go_to(direction)
    raise ArgumentError unless tile.starting_point? || possible_directions.include?(direction)

    new_line_no, new_column_no = [line_no, column_no].zip(DIRECTION_TO_NUMBERS.fetch(direction)).map(&:sum)
    Cursor.new(map, new_line_no, new_column_no, ALL_DIRECTIONS[3 - ALL_DIRECTIONS.find_index(direction)])
  end

  def tile
    @tile ||= map[line_no, column_no]
  end

  def possible_directions
    @possible_directions ||= POSSIBLE_DIRECTIONS.fetch(tile&.type, [])
  end

  def ==(other)
    return false unless other.is_a?(Cursor)

    line_no == other.line_no && column_no == other.column_no
  end

  def detect_tile_type!
    available_directions = ALL_DIRECTIONS.select.with_index do |direction, i|
      go_to(direction)&.possible_directions&.include?(ALL_DIRECTIONS[3 - i])
    end

    tile.type = POSSIBLE_DIRECTIONS.invert.fetch(available_directions)
  end
end
