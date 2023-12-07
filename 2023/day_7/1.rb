# frozen_string_literal: true

# nodoc
class Hand
  CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A].each_with_index.to_h.freeze # cards with their values
  COMBINATIONS = [
    [1, 1, 1, 1, 1], # high card
    [2, 1, 1, 1],    # one pair
    [2, 2, 1],       # two pairs
    [3, 1, 1],       # three of a kind
    [3, 2],          # full house
    [4, 1],          # four of a kind
    [5]              # five of a kind
  ].each_with_index.to_h.freeze

  attr_reader :cards

  def initialize(cards)
    @cards = cards.split('')
  end

  def type
    @type ||= begin
      amounts = cards.tally.values.sort.reverse
      COMBINATIONS.fetch(amounts)
    end
  end

  def <=>(other)
    types_equal = type <=> other.type
    return types_equal unless types_equal.zero?

    cards.zip(other.cards).each do |(card, other_card)|
      cards_equal = CARDS.fetch(card) <=> CARDS.fetch(other_card)
      return cards_equal unless cards_equal.zero?
    end

    0
  end
end

hands_and_bids = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map { _1.split(' ') }
                     .map { |(hand, bid)| [Hand.new(hand), bid.to_i] }

puts hands_and_bids.sort_by(&:first).map(&:last).each_with_index.inject(0) { |sum, (bid, index)| sum + bid * (index + 1) }
