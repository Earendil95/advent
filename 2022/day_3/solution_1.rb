priorities = ('a'..'z').zip(1..26).to_h.merge(('A'..'Z').zip(27..52).to_h)

rucksacks = File.readlines(ARGV[0] || "input", chomp: true).map { |rucksack| [rucksack.chars, rucksack.length] }

puts rucksacks.map { |(rucksack, size)| priorities[(rucksack[0..(size / 2 - 1)] & rucksack[(size / 2)..]).first] }.sum
