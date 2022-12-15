SENSOR_REGEXP = /^Sensor at x=(?<sensor_x>-?\d+), y=(?<sensor_y>-?\d+):/
BEACON_REGEXP = /closest beacon is at x=(?<beacon_x>-?\d+), y=(?<beacon_y>-?\d+)/
MAX_COORDINATE = (ARGV[1] || 4_000_000).to_i
MIN_COORDINATE = 0
TARGET_Y = (ARGV[1] || 2_000_000).to_i
input = File.readlines(ARGV[0] || "input")
 
sensors = input.map do |line|
  m = line.match(SENSOR_REGEXP)
  [m[:sensor_x].to_i, m[:sensor_y].to_i]
end

beacons = input.map do |line|
  m = line.match(BEACON_REGEXP)
  [m[:beacon_x].to_i, m[:beacon_y].to_i]
end

sensors_with_radius = sensors.zip(beacons).map do |((sensor_x, sensor_y), (beacon_x, beacon_y))|
  radius = (sensor_x - beacon_x).abs + (sensor_y - beacon_y).abs
  [sensor_x, sensor_y, radius]
end

ranges = []

sensors_with_radius.each do |(sensor_x, sensor_y, r)|
  x_range = r - (sensor_y - TARGET_Y).abs

  next if x_range < 0

  range = [sensor_x - x_range, sensor_x + x_range]

  next if ranges.any? { |existing_range| range.all? { |point|  point.between?(*existing_range) } }

  intersecting_ranges = [range] + ranges.select do |existing_range|
    range.any? { |point| point.between?(existing_range.first - 1, existing_range.last + 1) }
  end

  new_range = [intersecting_ranges.map(&:first).min, intersecting_ranges.map(&:last).max]
  ranges.delete_if { |existing_range| existing_range.all? { |point| point.between?(*new_range) } }
  ranges << new_range
end

puts ranges.map { |(left, right)| right - left + 1 }.sum - beacons.select { |b| b.last == TARGET_Y }.uniq.size
