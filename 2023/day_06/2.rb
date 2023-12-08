# frozen_string_literal: true

records = File.read(ARGV[0] || 'test_input.txt')

duration, distance = records.split("\n").map do |line|
  line.match(/(?:\d+\s*)+$/)[0].split(/\s+/).join.to_i
end

# 1. Find x1, x2 such as x * (duration - x) = distance, x1 < x2
# 2. It is the same as an equation: -x^2 + duration * x - distance = 0
# 3. Possible wins are x1.ceil..x2.floor => x2.floor - x1.ceil + 1
# 4. d is duration**2 - 4 * distance
# 5. Roots are ((-duration) +- d) / -2 => (duration +- d) / 2

d = Math.sqrt(duration**2 - 4 * distance)
x1 = (duration - d) / 2
x2 = (duration + d) / 2

# Edge case: when the roots are integers, we still have to change them
x1 += 1 if x1.to_i == x1
x2 -= 1 if x2.to_i == x2

puts x2.floor - x1.ceil + 1
