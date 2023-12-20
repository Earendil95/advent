# frozen_string_literal: true

require './src/beam'
require 'pry-byebug'

map = Field.new(File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map(&:chars))

corners = [[0, 0], [0, map.height - 1], [map.width - 1, 0], [map.width - 1, map.height - 1]]

starting_points = (1..(map.width - 2)).to_a.product([0, map.height - 1]) +
                  [0, map.width - 1].product((1..(map.height - 2)).to_a) +
                  corners

count = 0

# This bruteforce takes 50 mins to complete. Might be beneficial to add some caching
res = starting_points.flat_map do |(x, y)|
  directions = []
  directions << :right if x.zero?
  directions << :left if x == map.width - 1
  directions << :down if y.zero?
  directions << :up if y == map.height - 1

  directions.map do |d|
    Beam.new(x, y, d, map).longest_route.map { [_1.x, _1.y] }.to_set.size.tap do
      count += 1
      puts "counted #{count} out of #{map.width * 4}"
    end
  end
end.max

puts res
