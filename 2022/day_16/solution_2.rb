inputs = File.readlines(ARGV[0] || "input")

class Valve
  attr_reader :rate, :label
  attr_accessor :tunnels

  def initialize(rate:, tunnels: [], label:)
    @rate = rate
    @tunnels = tunnels
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
  debugger if data.nil?
  valves[data[:name]].tunnels = data[:tunnels].split(', ')
end

MINUTES_REMAINING = 26
@max = 0

def simulate(valves, minutes_remaining, current_labels, opened_valves, released, came_froms)
  return released if minutes_remaining <= 1
  return released if released + valves.slice(*(valves.keys - opened_valves)).values.map(&:rate).sum * (minutes_remaining - 1) < @max
  return released if valves.slice(*(valves.keys - opened_valves)).values.all? { |v| v.rate.zero? }

  possibilities = current_labels.map do |label|
    valve = valves[label]

    possibility = (valve.tunnels - [came_froms.first]).map { |tunnel| [tunnel, opened_valves, 0] }

    if !opened_valves.include?(label) && valve.rate > 0
      possibility.unshift([label, opened_valves + [label], (minutes_remaining - 1) * valve.rate])
    end

    possibility << [came_froms.first, opened_valves, 0] if possibility.empty?

    possibility
  end

  all_possibilities = possibilities.reduce { |a, e| a.product(e) }.reject { |possibility| possibility.all? { |p| p == possibility[0] } }

  results = all_possibilities.map do |possibility|
    new_labels = possibility.map { |p| p[0] }
    new_opened = possibility.map { |p| p[1] }.reduce { |a, e| a | e }
    additional_released = possibility.map { |p| p[2] }.sum

    simulate(valves, minutes_remaining - 1, new_labels, new_opened, released + additional_released, current_labels)
  end

  (results.max || released).tap do |current|
    @max = current if current > @max
  end
end

puts simulate(valves, MINUTES_REMAINING, ["AA", "AA"], [], 0, [])
