# frozen_string_literal: true

# nodoc
class Hand
  CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A].each_with_index.to_h.freeze # cards with their values
  COMBINATIONS = [
    [1, 1, 1, 1, 1], # high card
    [1, 1, 1, 2],    # one pair
    [1, 2, 2],       # two pairs
    [1, 1, 3],       # three of a kind
    [2, 3],          # full house
    [1, 4],          # four of a kind
    [5]              # five of a kind
  ].each_with_index.to_h.freeze

  attr_reader :cards

  def initialize(cards)
    @cards = cards.split('')
  end

  def type
    @type ||= begin
      amounts = cards.tally.values.sort
      COMBINATIONS.fetch(amounts)
    end
  end

  def <=>(other)
    types_cmp = type <=> other.type
    return types_cmp unless types_cmp.zero?

    cards.zip(other.cards).each do |(card, other_card)|
      cards_cmp = CARDS.fetch(card) <=> CARDS.fetch(other_card)
      return cards_cmp unless cards_cmp.zero?
    end

    0
  end
end

hands_and_bids = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map { _1.split(' ') }
                     .map { |(hand, bid)| [Hand.new(hand), bid.to_i] }

puts hands_and_bids.sort_by(&:first).map(&:last).each_with_index.inject(0) { |sum, (bid, index)| sum + bid * (index + 1) }
