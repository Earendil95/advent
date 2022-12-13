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

pairs = File.readlines(ARGV[0] || "input", chomp: true).delete_if(&:empty?).map(&method(:instance_eval)).each_slice(2).to_a

pairs.each_with_index.inject(0) do |result, ((left, right), index)|
  if comparison(left, right) == -1
    result + index + 1
  else
    result
  end
end => result

puts result
