# frozen_string_literal: true

# :nodoc:
class Galaxy
  attr_accessor :x, :y

  def initialize(x, y) # rubocop:disable Naming/MethodParameterName
    @x = x
    @y = y
  end

  def ==(other)
    return false unless other.is_a?(Galaxy)

    x == other.x && y == other.y
  end

  def pretty_print(pp)
    pp.text("[#{x}, #{y}]")
  end
end
