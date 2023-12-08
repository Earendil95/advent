# frozen_string_literal: true

# :nodoc:
class NodesNetwork
  def initialize
    @network = {}
  end

  def add_node(node)
    @network[node.label] = node
  end

  def fetch(label)
    @network.fetch(label)
  end
end

# :nodoc:
class Node
  attr_reader :label

  def initialize(string, network)
    @label, destinations = string.split(' = ')
    @destinations = %w[L R].zip(destinations[1..-2].split(', ')).to_h
    @network = network
  end

  def go_to(direction)
    @network.fetch(@destinations.fetch(direction))
  end
end

map = File.readlines(ARGV[0] || 'test_input_3.txt', chomp: true)

instructions = map[0]
nodes = map[2..]
nodes_network = NodesNetwork.new

nodes.map! { nodes_network.add_node(Node.new(_1, nodes_network)) }

current_nodes = nodes.select { _1.label.end_with?('A') }
steps_counts = []

current_nodes.each do |node|
  current_node = node
  steps_count = 0
  instruction_number = 0

  until current_node.label.end_with?('Z')
    direction = instructions[instruction_number]
    current_node = current_node.go_to(direction)
    steps_count += 1
    instruction_number = (instruction_number + 1) % instructions.size
  end

  steps_counts << steps_count
end

puts steps_counts.inject(1) { |a, e| a.lcm(e) }
