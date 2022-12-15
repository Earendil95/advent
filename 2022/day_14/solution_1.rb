paths = File.readlines(ARGV[0] || "input").map { |line| line.scan(/\d+,\d+/).map { |point| point.split(",").map(&:to_i) } }
all_points = paths.flatten(1)
shift = all_points.min_by(&:first).first

paths.map! { |path| path.map { |(x, y)| [x - shift, y] } }

STARTING_POINT = [500 - shift, 0]
WIDTH = all_points.max_by(&:first).first - shift + 1
DEPTH = all_points.max_by(&:last).last + 1
EMPTY_CELL = :'  '
ROCK_CELL = :'🪨 '

map = Array.new(WIDTH) { Array.new(DEPTH, EMPTY_CELL) }

# Fill in map
paths.each do |path|
  path.each_cons(2) do |((x1, y1), (x2, y2))|
    x_min, x_max = x1 < x2 ? [x1, x2] : [x2, x1]
    y_min, y_max = y1 < y2 ? [y1, y2] : [y2, y1]

    (x_min..x_max).to_a.product((y_min..y_max).to_a).each do |x, y|
      map[x][y] = ROCK_CELL
    end
  end
end

def print_map(map, unit = nil)
  system("clear")

  map.first.length.times do |layer|
    current_slice = map.map { |column| column[layer] }

    if unit&.last == layer
      current_slice[unit.first] = :'💧'
    end

    puts current_slice.join
  end

  true
end

total_units = 0

(0..).each do |i|
  sand_unit = STARTING_POINT.dup

  result = loop do
    if ENV['VISUALIZE'] == '1'
      print_map(map, sand_unit)
      sleep 0.1
    end

    if map[sand_unit.first][sand_unit.last + 1] == EMPTY_CELL
      column = map[sand_unit.first].each_with_index
      border = column.find_index { |cell, index| index > sand_unit.last && cell != EMPTY_CELL }
      break :void if border.nil?

      sand_unit[1] = border - 1
    elsif sand_unit.first.positive? && map[sand_unit.first - 1][sand_unit.last + 1] == EMPTY_CELL
      sand_unit = [sand_unit.first - 1, sand_unit.last + 1]
    elsif sand_unit.first.zero?
      break :void
    elsif sand_unit.first < WIDTH - 1 && map[sand_unit.first + 1][sand_unit.last + 1] == EMPTY_CELL
      sand_unit = [sand_unit.first + 1, sand_unit.last + 1]
    elsif sand_unit.first == WIDTH - 1
      break :void
    else
      map[sand_unit.first][sand_unit.last] = :'💧'
      total_units += 1
      break
    end
  end

  # print_map(map) && sleep(0.2) if i % 200 == 0
  break if result == :void
end

print_map(map)
puts "Total: #{total_units}"
