# frozen_string_literal: true

# :nodoc:
class Map
  attr_reader :tiles

  def initialize(data)
    @tiles = data.split("\n").map do |line|
      line.split('').map { |tile_type| Tile.new(tile_type) }
    end
  end

  def starting_point
    @starting_point ||= tiles.each_with_index do |line, line_no|
      column_no = line.find_index { _1.starting_point? }
      return [line_no, column_no] unless column_no.nil?
    end
  end

  def [](i, j) # rubocop:disable Naming/MethodParameterName
    return nil if [i, j].any?(&:negative?) || i >= tiles.size || j >= tiles.first.size

    tiles[i][j]
  end

  def each_with_index
    tiles.each_with_index do |line, i|
      line.each_with_index do |tile, j|
        yield tile, i, j
      end
    end
  end
end
