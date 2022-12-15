forest = File.readlines(ARGV[0] || "input", chomp: true).map { |line| line.split('').map(&:to_i) }

Tree = Struct.new(:x, :y, :height, keyword_init: true) do
  def visible_behind?(row)
    row.all? { |t| t < height }
  end

  def visible_from_left?(forest)
    visible_behind?(forest[y][..(x - 1)])
  end

  def visible_from_right?(forest)
    visible_behind?(forest[y][(x + 1)..])
  end

  def visible_from_top?(forest)
    visible_behind?(forest[..(y - 1)].map { |col| col[x] })
  end

  def visible_from_bottom?(forest)
    visible_behind?(forest[(y + 1)..].map { |col| col[x] })
  end

  def visible?(forest)
    visible_from_left?(forest) || visible_from_right?(forest) ||
      visible_from_top?(forest) || visible_from_bottom?(forest)
  end
end

visible_count = 2 * (forest.size + forest.first.size) - 4

(1..(forest.size - 2)).each do |y|
  (1..(forest.first.size - 2)).each do |x|
    tree = Tree.new(x: x, y: y, height: forest[y][x])
    visible_count += 1 if tree.visible?(forest)
  end
end

puts visible_count
