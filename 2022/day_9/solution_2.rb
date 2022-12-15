require "set"

TAILS_NUMBER = 9

directions = File.readlines(ARGV[0] || "input", chomp: true).flat_map do |line|
  direction, steps = line.split(' ')
  [direction] * steps.to_i
end

head = [0, 0]
tails = [[0, 0]] * TAILS_NUMBER
visited = Set.new

visited << tails.last.dup

def print_map(head, tails, visited)
  map = Array.new(21) { Array.new(26, '.') }
  system('clear')
  map.each_with_index.reverse_each do |row, y|
    visited.each_with_index do |tail|
      row[tail.first + 11] = '#' if y == tail.last + 5
    end
    tails.each_with_index.reverse_each do |tail, number|
      row[tail.first + 11] = number + 1 if y == tail.last + 5
    end
    row[head.first + 11] = "H" if y == head.last + 5
    puts row.join
  end
  sleep 0.5
end

def print_visited(visited)
  map = Array.new(21) { Array.new(26, '.') }
  system('clear')
  map.each_with_index.reverse_each do |row, y|
    visited.each_with_index do |tail|
      row[tail.first + 11] = '#' if y == tail.last + 5
    end
    puts row.join
  end
end

print_map(head, tails, visited) if ENV['VISUALIZE'] == '1'

directions.each do |direction|
  print_map(head, tails, visited) if ENV['VISUALIZE'] == '1'

  case direction
  when 'R' then head[0] += 1
  when 'L' then head[0] -= 1
  when 'U' then head[1] += 1
  when 'D' then head[1] -= 1
  end

  new_tails = [head]

  tails.each_with_index do |tail, i|
    previous_knot = new_tails[i]

    difference = previous_knot.zip(tail).map { |(h, t)| h - t }

    (new_tails << tail) && next if difference.all? { |d| d.abs <= 1 }

    new_tail = tail.dup
    new_tail[0] += difference[0] / difference[0].abs if difference[0] != 0
    new_tail[1] += difference[1] / difference[1].abs if difference[1] != 0

    new_tails << new_tail
  end

  tails = new_tails[1..]
  visited << tails.last.dup
end

print_map(head, tails, visited) if ENV['VISUALIZE'] == '1'
print_visited(visited) if ENV['VISUALIZE'] == '1'

puts visited.size
