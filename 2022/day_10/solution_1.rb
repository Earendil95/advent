commands = File.readlines(ARGV[0] || "input", chomp: true)

cycle_number = 1
addx_in_progress = false
x = 1
summary_strength = 0
command = ""

loop do
  command = commands.shift unless addx_in_progress

  if cycle_number % 40 == 20
    summary_strength += x * cycle_number
  end

  match = /addx (?<value>-?\d+)/.match(command)

  if match
    if addx_in_progress
      x += match[:value].to_i
      addx_in_progress = false
    else
      addx_in_progress = true
    end
  end

  cycle_number += 1
  break if commands.empty? && !addx_in_progress
end

puts summary_strength
