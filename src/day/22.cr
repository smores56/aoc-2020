require "./day"
require "big"

module Aoc
  class Day22 < Day
    def first(input)
      empty_index = input.index(&.empty?).not_nil!
      p1_cards = input[1...empty_index].map &.to_i
      p2_cards = input[(empty_index + 2)..].map &.to_i

      until p1_cards.empty? || p2_cards.empty?
        p1_card, p2_card = p1_cards.shift, p2_cards.shift
        if p1_card > p2_card
          p1_cards.push p1_card, p2_card
        else
          p2_cards.push p2_card, p1_card
        end
      end

      winner = p1_cards.empty? ? p2_cards : p1_cards
      winner
        .map_with_index { |card, index| BigInt.new((winner.size - index) * card) }
        .sum
    end

    def second(input)
      empty_index = input.index(&.empty?).not_nil!
      p1_cards = input[1...empty_index].map &.to_i
      p2_cards = input[(empty_index + 2)..].map &.to_i

      # p1_cards = [9, 2, 6, 3, 1]
      # p2_cards = [5, 8, 4, 7, 10]

      previous_rounds = [] of {Array(Int32), Array(Int32)}
      p1_won, winning_deck, repeated = recursive_combat p1_cards.dup, p2_cards.dup, previous_rounds
      winning_deck = p1_cards if repeated

      winning_deck
        .map_with_index { |card, index| BigInt.new((winning_deck.size - index) * card) }
        .sum
    end

    # returns whether P1 won, the winner's deck of cards, and
    # whether there was a repeat round
    def recursive_combat(p1_cards, p2_cards, previous_rounds) : Tuple(Bool, Array(Int32), Bool)
      until p1_cards.empty? || p2_cards.empty?
        return {true, p1_cards, true} if previous_rounds.includes?({p1_cards, p2_cards})
        previous_rounds.push({p1_cards.dup, p2_cards.dup})

        p1_card, p2_card = p1_cards.shift, p2_cards.shift
        p1_won = if p1_card <= p1_cards.size && p2_card <= p2_cards.size
                   p1_won_inner, winning_deck, repeated =
                     recursive_combat p1_cards[..p1_card], p2_cards[..p2_card], previous_rounds
                   return {true, winning_deck, true} if repeated
                   p1_won_inner
                 else
                   p1_card > p2_card
                 end

        if p1_won
          p1_cards.push p1_card, p2_card
        else
          p2_cards.push p2_card, p1_card
        end
      end

      {p2_cards.empty?, p2_cards.empty? ? p1_cards : p2_cards, false}
    end
  end
end
