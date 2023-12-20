# frozen_string_literal: true

# :nodoc:
class Field
  EMPTY = '.'
  MIRROR = %r{[/\\]}
  SPLITTER = /[-\|]/

  attr_reader :map

  def initialize(map)
    @map = map
  end

  def ==(other)
    other.is_a?(Field) && other.map == map
  end

  def [](x, y) # rubocop:disable Naming/MethodParameterName
    map[y][x]
  end

  def height
    map.size
  end

  def width
    map.first.size
  end
end
