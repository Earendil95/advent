game_scores = {
  "A X" => 3,
  "B X" => 1,
  "C X" => 2,
  "A Y" => 4,
  "B Y" => 5,
  "C Y" => 6,
  "A Z" => 8,
  "B Z" => 9,
  "C Z" => 7
}

puts File.readlines(ARGV[0] || "input", chomp: true).sum { |game| game_scores[game] }
