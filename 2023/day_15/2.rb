# frozen_string_literal: true

# :nodoc:
class Lense
  attr_accessor :strength, :position
  attr_reader :label

  def initialize(strength, position, label)
    @strength = strength
    @position = position
    @label = label
  end
end

def hash(string)
  string.chars.map(&:ord).inject(0) { |a, e| (a + e) * 17 } % 256
end

def add_lense(boxes, operation)
  label, strength = operation.split('=')
  box = boxes[hash(label)]
  position = box.key?(label) ? box[label].position : box.size + 1
  box[label] = Lense.new(strength.to_i, position, label)
end

def remove_lense(boxes, operation)
  label = operation[0..-2]
  box = boxes[hash(label)]
  removed_lense = box.delete(label)
  return if removed_lense.nil?

  box.transform_values { |lense| lense.position -= 1 if lense.position > removed_lense.position }
end

operations = File.read(ARGV[0] || 'test_input.txt').chomp.split(',')
boxes = Array.new(256) { {} }

operations.each do |operation|
  if operation.match?(/=\d+$/)
    add_lense(boxes, operation)
  else
    remove_lense(boxes, operation)
  end
end

summary_power = boxes.each_with_index.inject(0) do |total, (box, box_number)|
  (box_number + 1) * box.values.map { _1.strength * _1.position }.sum + total
end

puts summary_power
