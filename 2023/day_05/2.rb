# frozen_string_literal: true

require 'pry-byebug'

MyRange = Struct.new(:start, :finish, :transited) do
  def &(other)
    new_start = [start, other.start].max
    new_end = [finish, other.finish].min

    new_start <= new_end ? MyRange.new(new_start, new_end) : nil
  end

  def invalid?
    start > finish
  end

  # transition is pair of (source_range, shift)
  def apply(transition) # rubocop:disable Metrics/AbcSize
    return [self] if transited

    intersection = self & transition.first
    return [self] if intersection.nil?

    intersection_transited = MyRange.new(intersection.start + transition.last, intersection.finish + transition.last, true)

    [
      MyRange.new(start, intersection.start - 1),
      intersection_transited,
      MyRange.new(intersection.finish + 1, finish)
    ].reject(&:invalid?)
  end

  def pretty_print(pp)
    pp.text "(#{start}..#{finish})"
  end
end

maps = File.read(ARGV[0] || 'test_input.txt').split("\n\n")

seeds = maps.shift.match(/seeds: ((?:\d+\s?)+)/)[1].split(' ').map(&:to_i).each_slice(2).to_a.map do |(beginning, length)|
  MyRange.new(beginning, beginning + length - 1)
end

maps.each do |map|
  transitions = map.lines[1..].map { _1.split(' ').map(&:to_i) }.map do |(destination, source, length)|
    [MyRange.new(source, source + length - 1), destination - source]
  end

  seeds.map! do |seed|
    [seed].tap do |results|
      transitions.each do |transition|
        results.map! { |r| r.apply(transition) }.flatten!
      end
    end
  end.flatten!

  # we're done with a set of transitions, the transitions from the next set should be applicable
  seeds.each { _1.transited = false }
end

puts seeds.map(&:start).min
