# frozen_string_literal: true

require_relative 'field'

# :nodoc
class Beam
  attr_reader :x, :y, :direction, :field

  REFLECTIONS = {
    '/' => {
      right: :up,
      up: :right,
      left: :down,
      down: :left
    },
    '\\' => {
      right: :down,
      down: :right,
      left: :up,
      up: :left
    }
  }.freeze

  MOVING_DELTAS = {
    right: [1, 0],
    left: [-1, 0],
    up: [0, -1],
    down: [0, 1]
  }.freeze

  SPLITS = {
    right: %i[up down],
    left: %i[up down],
    up: %i[left right],
    down: %i[left right]
  }.freeze

  def initialize(x, y, direction, field) # rubocop:disable Naming/MethodParameterName
    @x = x
    @y = y
    @direction = direction
    @field = field
  end

  def longest_route
    beams = Set[self]
    current_beams = Set[self]

    loop do
      current_beams.map!(&:move).flatten!
      break if current_beams <= beams

      beams |= current_beams
    end

    beams
  end

  def move
    new_beams = case current_tile
                when Field::EMPTY then move_forward
                when Field::MIRROR then reflect
                when Field::SPLITTER then split
                end

    new_beams.select(&:inbound?).to_set
  end

  def ==(other)
    other.is_a?(Beam) && other.x == x && other.y == y && other.direction == direction && other.field == field
  end

  alias eql? ==

  def hash
    @hash ||= [x, y, direction].join(',').hash
  end

  def inbound?
    (0..(field.height - 1)).cover?(y) && (0..(field.width - 1)).cover?(x)
  end

  def pretty_print(pp)
    pp.text("Beam<#{[x, y, direction].join(', ')}>")
  end

  private

  def current_tile
    field[x, y]
  end

  def move_forward
    delta_x, delta_y = MOVING_DELTAS[direction]

    Set[Beam.new(x + delta_x, y + delta_y, direction, field)]
  end

  def reflect
    with_direction(REFLECTIONS[current_tile][direction]) { move_forward }
  end

  def split
    if should_split?
      SPLITS[direction].map { with_direction(_1) { move_forward } }.inject(&:|)
    else
      move_forward
    end
  end

  def with_direction(direction, &)
    old_direction = @direction
    @direction = direction
    yield
  ensure
    @direction = old_direction
  end

  def should_split?
    (%i[left right].include?(direction) && current_tile == '|') ||
      (%i[up down].include?(direction) && current_tile == '-')
  end
end
