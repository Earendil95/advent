# frozen_string_literal: true

input = File.read(ARGV[0] || 'test_input.txt').chomp.split(',')

puts input.map { _1.chars.map(&:ord).inject(0) { |a, e| (a + e) * 17 } % 256 }.sum
