# frozen_string_literal: true

# nodoc
class Hand
  CARDS = %w[J 2 3 4 5 6 7 8 9 T Q K A].each_with_index.to_h.freeze # cards with their values
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
      amounts[top_combination.first] += amounts.delete('J').to_i unless top_combination.first == 'J' # five Js edgecase

      COMBINATIONS.fetch(amounts.values.sort)
    end
  end

  def to_i
    [type + 1, *cards.map { CARDS.fetch(_1).to_s(16) }].join.to_i(16)
  end

  private

  def amounts
    @amounts ||= cards.tally
  end

  def top_combination
    amounts.to_a.max do |(card_a, amount_a), (card_b, amount_b)|
      next -1 if card_a == 'J'
      next 1 if card_b == 'J'

      amount_a <=> amount_b
    end
  end
end

hands_and_bids = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map { _1.split(' ') }
                     .map { |(hand, bid)| [Hand.new(hand), bid.to_i] }

puts hands_and_bids.sort_by { _1.first.to_i }.map(&:last).each_with_index
                   .inject(0) { |sum, (bid, index)| sum + bid * (index + 1) }
