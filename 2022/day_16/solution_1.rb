inputs = File.readlines(ARGV[0] || "input")

class Valve
  attr_reader :rate, :label
  attr_accessor :paths

  def initialize(rate:, tunnels: [], label:)
    @rate = rate
    @label = label
  end
end

valves = {}
inputs.each do |valve|
  data = valve.match /Valve (?<name>[A-Z]{2}) has flow rate=(?<rate>\d+);/
  valves[data[:name]] = Valve.new(rate: data[:rate].to_i, label: data[:name])
end

inputs.each do |valve|
  data = valve.match /Valve (?<name>[A-Z]{2}) has flow rate=(?:\d+); tunnels? leads? to valves? (?<tunnels>(?:[A-Z]{2}(, )?)+)/
  valves[data[:name]].paths = data[:tunnels].split(', ').map { |label| [label, 1] }.to_h
end

valves.select { |_, valve| valve.rate == 0 && valve.label != "AA" }.each do |label, valve|
  valves.delete(label)

  valve.paths.each do |to, lenght|
    valve.paths.each do |path, length|
      next if path == to
      
      valves[to].paths[path] = length + valves[to].paths[label]
    end

    valves[to].paths.delete(valve.label)
  end
end

pp valves

# MINUTES_REMAINING = 30
# @max = 0

# def simulate(valves, minutes_remaining, current_label, opened_valves, released, came_from)
#   return released if minutes_remaining == 0
#   return released if released + valves.slice(*(valves.keys - opened_valves)).values.map(&:rate).sum * (minutes_remaining - 1) < @max
#   return released if valves.slice(*(valves.keys - opened_valves)).values.all? { |v| v.rate.zero? }

#   current_valve = valves[current_label]

#   possibilities = (current_valve.tunnels - [came_from]).map { |tunnel| [tunnel, opened_valves, released] }

#   if !opened_valves.include?(current_label) && current_valve.rate > 0
#     possibilities.unshift([current_label, opened_valves + [current_label], released + (minutes_remaining - 1) * current_valve.rate])
#   end

#   possibilities << [came_from, opened_valves, released] if possibilities.empty?

#   possibilities.map { |possibility| simulate(valves, minutes_remaining - 1, *possibility, current_label) }.max.tap do |current|
#     @max = current if current > @max
#   end
# end

# puts simulate(valves, MINUTES_REMAINING, "AA", [], 0, nil)
