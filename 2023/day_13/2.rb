# frozen_string_literal: true

def possible_axis(line, check_axis = (1..(line.length - 1)).to_a)
  different_characters_count = check_axis.map do |symmetry|
    left = line[0..(symmetry - 1)]
    right_reversed = line[symmetry..].reverse

    shorter, longer = [left, right_reversed].minmax_by(&:length)

    longer = longer[-shorter.size..]

    [symmetry, longer.zip(shorter).count { |(a, b)| a != b }]
  end

  different_characters_count.select { _1.last <= 1 }.to_h
end

def find_vertical_axis(map)
  initial_axis = (1..(map.first.size - 1)).to_a.zip([0] * (map.first.size - 1)).to_h

  counts = map.inject(initial_axis) do |axis, line|
    possibilities = possible_axis(line, axis.map(&:first))
    break if possibilities.empty?

    axis.slice(*possibilities.keys).map { [_1, _2 + possibilities[_1]] }.to_h
  end

  counts&.select { _2 == 1 }&.keys&.first
end

patterns = File.read(ARGV[0] || 'test_input.txt').split("\n\n").map do |pattern|
  pattern.split("\n").map { _1.split('') }
end

# result
result = patterns.inject(0) do |a, e|
  a + (find_vertical_axis(e) || 100 * find_vertical_axis(e.transpose))
end
puts result
