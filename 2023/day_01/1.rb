# frozen_string_literal: true

lines = File.readlines(ARGV[0] || 'input.txt', chomp: true)

sum = lines.map do |line|
  first_digit = line.match(/^\D*(\d)/)[1]
  last_digit = line.match(/(\d)\D*$/)[1]
  (first_digit + last_digit).to_i
end.sum

puts sum
