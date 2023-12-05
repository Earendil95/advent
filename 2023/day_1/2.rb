# frozen_string_literal: true

DIGITS_SPELLED = %w[zero one two three four five six seven eight nine].freeze
DIGITS_SPELLED_REVERSED = DIGITS_SPELLED.map(&:reverse).freeze
REGEXP = Regexp.new("(#{[*DIGITS_SPELLED, '\d'].join('|')})").freeze
REGEXP_REVERSED = Regexp.new("(#{[*DIGITS_SPELLED_REVERSED, '\d'].join('|')})").freeze

NAMES_TO_DIGITS = (DIGITS_SPELLED.each_with_index + DIGITS_SPELLED_REVERSED.each_with_index).to_h.transform_values(&:to_s).freeze

lines = File.readlines(ARGV[0] || 'input.txt', chomp: true)

sum = lines.map do |line|
  first_digit = line.match(REGEXP)[0]
  last_digit = line.reverse.match(REGEXP_REVERSED)[0]
  (NAMES_TO_DIGITS.fetch(first_digit, first_digit) + NAMES_TO_DIGITS.fetch(last_digit, last_digit)).to_i
end.sum

puts sum
