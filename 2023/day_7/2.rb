# frozen_string_literal: true

# nodoc
class Hand
  CARDS = %w[J 2 3 4 5 6 7 8 9 T Q K A].each_with_index.to_h.freeze # cards with their values
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
      amounts[top_combination.first] += amounts.delete('J').to_i unless top_combination.first == 'J' # five Js edgecase

      COMBINATIONS.fetch(amounts.values.sort.reverse)
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

  private

  def amounts
    @amounts ||= cards.tally
  end

  def top_combination
    amounts.to_a.max do |(card_a, amount_a), (card_b, amount_b)|
      next -1 if card_a == 'J'
      next 1 if card_b == 'J'

      amount_cmp = amount_a <=> amount_b
      next amount_cmp unless amount_cmp.zero?

      CARDS.fetch(card_a) <=> CARDS.fetch(card_b)
    end
  end
end

hands_and_bids = File.readlines(ARGV[0] || 'test_input.txt', chomp: true).map { _1.split(' ') }
                     .map { |(hand, bid)| [Hand.new(hand), bid.to_i] }

puts hands_and_bids.sort_by(&:first).map(&:last).each_with_index
                   .inject(0) { |sum, (bid, index)| sum + bid * (index + 1) }
