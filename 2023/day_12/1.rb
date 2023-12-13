# frozen_string_literal: true

require 'pry-byebug'

def count_possible_options(line, numbers)
  return 1 if numbers.empty? && (line.nil? || !line.include?('#'))
  return 0 if line.length < numbers.sum + numbers.size - 1
  return 1 if line == numbers.map { '#' * _1 }.join('.')

  if line.start_with?('.')
    count_possible_options(line[1..], numbers)
  elsif line.start_with?('#')
    match = line.match(/^[#?]{#{numbers.first}}(?:[.?].*)?$/)
    return 0 if match.nil?

    count_possible_options(line[numbers.first.next..], numbers[1..])
  else
    count_possible_options(line.sub('?', '.'), numbers) + count_possible_options(line.sub('?', '#'), numbers)
  end
end

data = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map do |line|
  line, numbers = line.split(' ')
  numbers = numbers.split(',').map(&:to_i)
  [line, numbers]
end

puts(data.map { |(line, numbers)| count_possible_options(line, numbers) }.sum)
