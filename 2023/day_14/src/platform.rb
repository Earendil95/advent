# frozen_string_literal: true

# :nodoc:
class Platform
  CUBE = '#'
  ROUNDED_ROCK = 'O'
  EMPTY_SPACE = '.'

  attr_reader :map

  def initialize(map)
    @map = map
  end

  def spin_cycle!
    tilt_north!
    tilt_west!
    tilt_south!
    tilt_east!
  end

  def tilt_north!
    @map = map.transpose.map { tilt_row_west(_1) }.transpose
  end

  def tilt_south!
    @map = map.transpose.map { tilt_row_west(_1.reverse).reverse }.transpose
  end

  def tilt_west!
    @map = map.map { tilt_row_west(_1) }
  end

  def tilt_east!
    @map = map.map { tilt_row_west(_1.reverse).reverse }
  end

  def count_load
    total_rows = map.size
    map.each_with_index.inject(0) do |sum, (row, i)|
      sum + row.count(ROUNDED_ROCK) * (total_rows - i)
    end
  end

  def ==(other)
    other.is_a?(Platform) && other.map == map
  end

  private

  def tilt_row_west(row)
    # -1 is the north edge
    cube_ranges = [-1, *row.each_with_index.select { _1.first == CUBE }.map(&:last), row.size].each_cons(2)
    rounded_rocks_numbers = cube_ranges.map { |(from, to)| to - from == 1 ? 0 : row[(from + 1)..(to - 1)].count(ROUNDED_ROCK) }

    cube_ranges.each_with_index.inject([]) do |transformed_column, ((cube_position, next_cube_position), cube_number)|
      transformed_column[cube_position] = CUBE unless cube_position == -1

      rounded_rocks_number = rounded_rocks_numbers[cube_number]
      empty_number = next_cube_position - cube_position - 1 - rounded_rocks_number
      transformed_column + [ROUNDED_ROCK] * rounded_rocks_number + [EMPTY_SPACE] * empty_number
    end
  end
end
