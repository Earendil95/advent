SENSOR_REGEXP = /^Sensor at x=(?<sensor_x>-?\d+), y=(?<sensor_y>-?\d+):/
BEACON_REGEXP = /closest beacon is at x=(?<beacon_x>-?\d+), y=(?<beacon_y>-?\d+)/
MAX_COORDINATE = (ARGV[1] || 4_000_000).to_i
MIN_COORDINATE = 0
TARGET_Y = 10
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

map = []

sensors_with_radius.each do |(sensor_x, sensor_y, r)|
  ([sensor_y - r, MIN_COORDINATE].max..[sensor_y + r, MAX_COORDINATE].min).each do |y|
    x_range = r - (sensor_y - y).abs

    range = [[sensor_x - x_range, MIN_COORDINATE].max, [sensor_x + x_range, MAX_COORDINATE].min]

    map[y] ||= []

    next if map[y].any? { |existing_range| range.all? { |point|  point.between?(*existing_range) } }

    intersecting_ranges = [range] + map[y].select do |existing_range|
      range.any? { |point| point.between?(existing_range.first - 1, existing_range.last + 1) }
    end

    new_range = [intersecting_ranges.map(&:first).min, intersecting_ranges.map(&:last).max]
    map[y].delete_if { |existing_range| existing_range.all? { |point| point.between?(*new_range) } }
    map[y] << new_range
  end
end

y = map.find_index { |column| column.size > 1 }
x = map[y].sort_by(&:first).first.last + 1

p x * 4_000_000 + y
