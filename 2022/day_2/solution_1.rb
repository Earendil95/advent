game_scores = {
  "A X" => 4,
  "B X" => 1,
  "C X" => 7,
  "A Y" => 8,
  "B Y" => 5,
  "C Y" => 2,
  "A Z" => 3,
  "B Z" => 9,
  "C Z" => 6
}

puts File.readlines(ARGV[0] || "input", chomp: true).sum { |game| game_scores[game] }
