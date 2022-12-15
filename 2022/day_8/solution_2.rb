forest = File.readlines(ARGV[0] || "input", chomp: true).map { |line| line.split('').map(&:to_i) }

Tree = Struct.new(:x, :y, :height, keyword_init: true) do
  def sees_in(row)
    return 0 if row.empty?

    (row.find_index { |tree| tree >= height } || row.size - 1) + 1
  end

  def sees_on_left(forest)
    sees_in(forest[y][..(x - 1)].reverse)
  end

  def sees_on_right(forest)
    sees_in(forest[y][(x + 1)..])
  end

  def sees_on_top(forest)
    sees_in(forest[..(y - 1)].map { |column| column[x] }.reverse)
  end

  def sees_on_bottom(forest)
    sees_in(forest[(y + 1)..].map { |column| column[x] })
  end

  def scenic_score(forest)
    sees_on_left(forest) * sees_on_right(forest) * sees_on_top(forest) * sees_on_bottom(forest)
  end
end

max_score = 0

(1..(forest.size - 2)).each do |y|
  (1..(forest.first.size - 2)).each do |x|
    tree = Tree.new(x: x, y: y, height: forest[y][x])
    score = tree.scenic_score(forest)

    max_score = score if score > max_score
  end
end

puts max_score
