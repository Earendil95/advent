# frozen_string_literal: true

POSSIBLE = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

games = File.readlines(ARGV[0] || 'test_input.txt', chomp: true)

ids_and_games = games.map do |game|
  id, game = game.split(': ')
  [id.match(/\d+/)[0].to_i, game]
end.to_h

possible_games = ids_and_games.select do |_, game|
  trials = game.split('; ').map do |trial|
    trial.split(', ').map { _1.split(' ').reverse }.to_h
  end

  trials.all? { |trial| trial.all? { |color, number| number.to_i <= POSSIBLE[color] } }
end

puts possible_games.keys.sum
