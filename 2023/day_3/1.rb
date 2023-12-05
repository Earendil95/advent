# frozen_string_literal: true

DIGITS = %w[0 1 2 3 4 5 6 7 8 9].freeze

# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
def symbol_adjacent?(schema, row_number, col_number, number)
  search_row_min = [row_number - 1, 0].max
  search_row_max = [row_number + 1, schema.size - 1].min
  search_col_min = [col_number - 1, 0].max
  search_col_max = [col_number + number.size, schema.first.size - 1].min

  rows = [search_row_min, search_row_max].reject { _1 == row_number }
  cols = [search_col_min, search_col_max].reject { [col_number, col_number + number.size - 1].include?(_1) }

  rows.each do |i|
    (search_col_min..search_col_max).each do |j|
      return true unless schema[i][j].nil? || DIGITS.include?(schema[i][j])
    end
  end

  cols.each do |j|
    (search_row_min..search_row_max).each do |i|
      return true unless schema[i][j].nil? || DIGITS.include?(schema[i][j])
    end
  end

  false
end
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength

schema = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map(&:chars)

schema.map! { |row| row.map! { _1 == '.' ? nil : _1 } }

sum = 0

schema.each_with_index do |row, row_number|
  current_number = []

  row.each_cons(2).with_index do |cells, col_number|
    next unless DIGITS.include?(cells.first)

    current_number << cells.first

    if cells.last.nil? || !DIGITS.include?(cells.last) || col_number == row.size - 2
      unless cells.last.nil? || !DIGITS.include?(cells.last)
        current_number << cells.last
        col_number += 1
      end

      if symbol_adjacent?(schema, row_number, col_number - current_number.size + 1, current_number)
        sum += current_number.join.to_i
      end

      current_number = []
    end
  end
end

puts sum
