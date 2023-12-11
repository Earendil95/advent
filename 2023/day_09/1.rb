# frozen_string_literal: true

# :nodoc:
class SensorData
  attr_reader :measures

  def initialize(measures)
    @measures = measures
  end

  def predict!
    build_differences

    until differences.size == 1
      difference = differences.pop.last
      differences.last.push(differences.last.last + difference)
    end

    @measures = differences.first
  end

  private

  attr_reader :differences

  def build_differences
    @differences = [measures]

    differences.push(differences.last.each_cons(2).map { |(a, b)| b - a }) until differences.last.all?(&:zero?)
  end
end

data = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map { |line| SensorData.new(line.split(' ').map(&:to_i)) }

data.each(&:predict!)

puts data.map(&:measures).map(&:last).sum
