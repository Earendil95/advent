def comparison(left, right)
  case [left, right]
  in [_, nil]           then 1
  in [nil, _]           then -1
  in [Integer, Integer] then left <=> right
  in [Array, Array]
    [left.size, right.size].max.times do |index|
      comparison(left[index], right[index]).then { |result| return result if result != 0 }
    end

    0
  else
    comparison(Array(left), Array(right))
  end
end

input = File.readlines(ARGV[0] || "input", chomp: true).delete_if(&:empty?).map(&method(:instance_eval)).to_a

input.sort! { |a, b| comparison(a, b) }

dividers = [[[2]], [[6]]]

dividers.each_with_index.inject(1) do |acc, (divider, index)|
  acc * (index + 1 + input.find_index { |element| comparison(divider, element) == -1 })
end => result

puts result
