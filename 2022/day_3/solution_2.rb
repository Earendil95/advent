priorities = ('a'..'z').zip(1..26).to_h.merge(('A'..'Z').zip(27..52).to_h)

rucksacks = File.readlines(ARGV[0] || "input", chomp: true).map(&:chars)

puts rucksacks.each_slice(3).map { |(one, two, three)| priorities[(one & two & three).first] }.sum
