# frozen_string_literal: true

games = File.readlines(ARGV[0] || 'test_input.txt', chomp: true)

games = games.map { _1.split(': ').last }.map do |game|
  game.split('; ').map do |trial|
    trial.split(', ').map { _1.split(' ').reverse }.to_h
  end
end

minimal_cubes = games.map do |game|
  {
    'red' => game.map { _1['red'].to_i }.max,
    'green' => game.map { _1['green'].to_i }.max,
    'blue' => game.map { _1['blue'].to_i }.max
  }
end

puts minimal_cubes.map { _1.values.inject(:*) }.sum
