pairs = File.readlines(ARGV[0] || "input", chomp: true).map do |pair|
  pair.split(/[,\-]/).map(&:to_i).each_slice(2).to_a
end

result = pairs.count do |(start_1, finish_1), (start_2, finish_2)|
  (start_1 <= start_2 && finish_1 >= finish_2) || (start_1 >= start_2 && finish_1 <= finish_2)
end

puts result
