# frozen_string_literal: true

# first 100 states
# 104, 87, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69, 64, 69, 63, 65, 65, 63, 69
# cycle
# 64, 69, 63, 65, 65, 63, 69

require './src/platform'

TARGET = 1_000_000_000

platform = Platform.new(File.read(ARGV[0] || 'test_input.txt').split("\n").map { _1.split('') })

states = [platform.map]
cycle_starts = nil

loop do
  platform.spin_cycle!

  cycle_starts = states.find_index(platform.map)
  break unless cycle_starts.nil?

  states << platform.map
end

cycle = states[cycle_starts..]
cycle_length = cycle.size

cycle = states[cycle_starts..]
target_state = cycle[(TARGET - cycle_starts) % cycle_length]

puts Platform.new(target_state).count_load
