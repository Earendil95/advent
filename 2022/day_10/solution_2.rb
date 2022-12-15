commands = File.readlines(ARGV[0] || "input", chomp: true)

cycle_number = 1
addx_in_progress = false
x = 1
command = ""
crt = []

loop do
  command = commands.shift unless addx_in_progress

  crt << ((x - ((cycle_number - 1) % 40)).abs <= 1 ? '█' : ' ')

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

system('clear')
puts crt.each_slice(40).map { |row| row.join }.join("\n") + "\n\n\n"
