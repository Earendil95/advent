# frozen_string_literal: true

require 'pry-byebug'

def count_possible_options(line, numbers, memo = {})
  return memo[line.to_s + numbers.join(',')] if memo.key?(line.to_s + numbers.join(','))

  result = if numbers.empty? && (line.nil? || !line.include?('#'))
             1
           elsif line.length < numbers.sum + numbers.size - 1
             0
           elsif line == numbers.map { '#' * _1 }.join('.')
             1
           elsif line.start_with?('.')
             count_possible_options(line[1..], numbers, memo)
           elsif line.start_with?('#')
             match = line.match(/^[#?]{#{numbers.first}}(?:[.?].*)?$/)
             return 0 if match.nil?

             count_possible_options(line[numbers.first.next..], numbers[1..], memo)
           else
             count_possible_options(line.sub('?', '.'), numbers, memo) + count_possible_options(line.sub('?', '#'), numbers, memo)
           end

  memo[line.to_s + numbers.join(',')] = result
  result
end

data = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map do |line|
  line, numbers = line.split(' ')
  numbers = numbers.split(',').map(&:to_i)
  [([line] * 5).join('?'), numbers * 5]
end

puts(data.map { |(line, numbers)| count_possible_options(line, numbers) }.sum)
