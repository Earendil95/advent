# test input
# stacks = [
#   %w[N Z],
#   %w[D C M],
#   %w[P],
# ].map(&:reverse)

# real input
stacks = [
  %w[Q G P R L C T F],
  %w[J S F R W H Q N],
  %w[Q M P W H B F],
  %w[F D T S V],
  %w[Z F V W D L Q],
  %w[S L C Z],
  %w[F D V M B Z],
  %w[B J T],
  %w[H P S L G B N Q]
].map(&:reverse)

REGEXP = /\Amove (?<number>\d+) from (?<from>\d+) to (?<to>\d+)\z/.freeze

moves = File.readlines(ARGV[0] || "input", chomp: true)

moves.each do |move|
  command = move.match(REGEXP)
  stacks[command[:to].to_i - 1] += stacks[command[:from].to_i - 1].pop(command[:number].to_i).reverse
end

puts stacks.map(&:last).join('')
