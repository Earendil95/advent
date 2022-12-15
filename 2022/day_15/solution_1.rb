SENSOR_REGEXP = /^Sensor at x=(?<sensor_x>-?\d+), y=(?<sensor_y>-?\d+):/
BEACON_REGEXP = /closest beacon is at x=(?<beacon_x>-?\d+), y=(?<beacon_y>-?\d+)/
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

impossible_xs = sensors_with_radius.map do |(sensor_x, sensor_y, radius)|
  height = (sensor_y - TARGET_Y).abs
  coverage = radius - height
  ((sensor_x - coverage)..(sensor_x + coverage)).to_a
end

puts impossible_xs.flatten.uniq.size - beacons.select { |b| b.last == TARGET_Y }.uniq.size
