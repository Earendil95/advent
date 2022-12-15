require "set"

directions = File.readlines(ARGV[0] || "input", chomp: true).flat_map do |line|
  direction, steps = line.split(' ')
  [direction] * steps.to_i
end

head = [0, 0]
tail = [0, 0]
visited = Set.new

visited << tail.dup

def print_map(head, tail, visited)
  map = Array.new(11) { Array.new(11, '.') }
  system('clear')
  map.each_with_index.reverse_each do |row, y|
    row[tail.first + 5] = "T" if y == tail.last + 5
    row[head.first + 5] = "H" if y == head.last + 5
    puts row.join
  end
  # p visited
end

# print_map(head, tail, visited)
# sleep 0.5

directions.each do |direction|
  # print_map(head, tail, visited)
  # sleep 0.5

  case direction
  when 'R' then head[0] += 1
  when 'L' then head[0] -= 1
  when 'U' then head[1] += 1
  when 'D' then head[1] -= 1
  end

  difference = head.zip(tail).map { |(h, t)| h - t }

  next if difference.all? { |d| d.abs <= 1 }

  tail[0] += difference[0] / difference[0].abs if difference[0] != 0
  tail[1] += difference[1] / difference[1].abs if difference[1] != 0

  visited << tail.dup
end

# print_map(head, tail, visited)

puts visited.size
