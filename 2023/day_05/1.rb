# frozen_string_literal: true

maps = File.read(ARGV[0] || 'test_input.txt').split("\n\n")

seeds = maps.shift.match(/seeds: ((?:\d+\s?)+)/)[1].split(' ').map(&:to_i)

maps.each do |map|
  transitions = map.lines[1..].map { _1.split(' ').map(&:to_i) }

  seeds.map! do |seed|
    destination, source, = transitions.find { |(_, source, length)| (source..(source + length - 1)).cover? seed }

    destination ? destination + seed - source : seed
  end
end

puts seeds.min
