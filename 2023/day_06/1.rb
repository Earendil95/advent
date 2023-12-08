# frozen_string_literal: true

records = File.read(ARGV[0] || 'test_input.txt')

durations, distances = records.split("\n").map do |line|
  line.match(/(?:\d+\s*)+$/)[0].split(/\s+/).map(&:to_i)
end

winning_possibilities = durations.zip(distances).map do |(duration, distance)|
  d = Math.sqrt(duration**2 - 4 * distance)
  x1 = (duration - d) / 2
  x2 = (duration + d) / 2

  # Edge case: when the roots are integers, we still have to change them
  x1 += 1 if x1.to_i == x1
  x2 -= 1 if x2.to_i == x2

  x2.floor - x1.ceil + 1
end

puts winning_possibilities.inject(:*)
