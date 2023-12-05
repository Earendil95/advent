# frozen_string_literal: true

cards = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map do |card|
  data = card.match(/^Card\s+\d+:\s+((?:\d+\s*?)+) \|\s+((?:\d+\s*)+)$/).to_a[1..2]
  [data.map { _1.split(/\s+/).map(&:to_i) }, 1]
end

cards.map.with_index do |((winning, my), amount), i|
  matching = (winning & my).size

  next if matching.zero?

  cards[(i + 1)..(i + matching)].each { _1[-1] += amount }
end

puts cards.map(&:last).sum
