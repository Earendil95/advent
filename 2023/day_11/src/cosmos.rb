# frozen_string_literal: true

require_relative 'galaxy'

# :nodoc:
class Cosmos
  attr_reader :map, :galaxies

  def initialize(map)
    @galaxies = []
    @map = map.split("\n").map.with_index do |row, i|
      row.split('').each_with_index { |point, j| @galaxies << Galaxy.new(i, j) if point == '#' }
    end
  end

  def expand!(expansion = 2) # rubocop:disable Metrics/AbcSize
    each_empty_row_index(map) do |row_number|
      galaxies.select { |g| g.x > row_number }.each { |g| g.x += expansion - 1 }
    end

    each_empty_row_index(map.transpose) do |column_number|
      galaxies.select { |g| g.y > column_number }.each { |g| g.y += expansion - 1 }
    end
  end

  private

  def each_empty_row_index(map)
    map.each_with_index.to_a.reverse.each do |(row, i)|
      yield i if row.all?('.')
    end
  end
end
