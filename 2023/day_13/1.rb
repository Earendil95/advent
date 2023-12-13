# frozen_string_literal: true

def possible_axis(line, check_axis = (1..(line.length - 1)).to_a)
  check_axis.select do |symmetry|
    left = line[0..(symmetry - 1)]
    right_reversed = line[symmetry..].reverse

    shorter, longer = [left, right_reversed].minmax_by(&:length)

    longer[-shorter.size..] == shorter
  end
end

def find_vertical_axis(map)
  map.inject((1..(map.first.size - 1)).to_a) do |axis, line|
    possibilities = possible_axis(line, axis)
    break if possibilities.empty?

    axis & possibilities
  end&.first
end

patterns = File.read(ARGV[0] || 'test_input.txt').split("\n\n").map do |pattern|
  pattern.split("\n").map { _1.split('') }
end

# result
result = patterns.inject(0) do |a, e|
  a + (find_vertical_axis(e) || 100 * find_vertical_axis(e.transpose))
end
puts result
