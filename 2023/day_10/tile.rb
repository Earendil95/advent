# frozen_string_literal: true

# :nodoc:
class Tile
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def starting_point?
    type == 'S'
  end
end
