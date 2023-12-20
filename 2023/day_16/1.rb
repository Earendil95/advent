# frozen_string_literal: true

require './src/beam'
require 'pry-byebug'

map = Field.new(File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map(&:chars))
beams = Set[Beam.new(0, 0, :right, map)]
current_beams = Set[Beam.new(0, 0, :right, map)]

loop do
  current_beams.map!(&:move).flatten!
  break if current_beams <= beams

  beams |= current_beams
end

puts beams.map { [_1.x, _1.y] }.to_set.size
