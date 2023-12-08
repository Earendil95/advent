# frozen_string_literal: true

cards = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map do |card|
  data = card.match(/^Card\s+\d+:\s+((?:\d+\s*?)+) \|\s+((?:\d+\s*)+)$/).to_a[1..2]
  data.map { _1.split(/\s+/).map(&:to_i) }
end

puts cards.map { 2**((_1[0] & _1[1]).size - 1) }.map(&:to_i).sum
