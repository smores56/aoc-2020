require "./day"
require "big"

module Aoc
  class Day25 < Day
    # transform(7, card_loop_size) = card_public_key
    # transform(7, door_loop_size) = door_public_key
    #
    # transform(door_public_key, card_loop_size) =
    # transform(card_public_key, door_loop_size) =
    #   encryption_key
    def first(input)
      door_public_key = input[0].to_i
      card_public_key = input[1].to_i

      loop_size_channel = Channel({Int32, Bool}).new

      spawn do
        card_loop_size = find_loop_size card_public_key
        loop_size_channel.send({card_loop_size, true})
      end

      spawn do
        door_loop_size = find_loop_size door_public_key
        loop_size_channel.send({door_loop_size, false})
      end

      loop_size, for_card = loop_size_channel.receive
      if for_card
        transform door_public_key, loop_size
      else
        transform card_public_key, loop_size
      end
    end

    def second(input)
      input.size # TODO
    end

    def find_loop_size(public_key)
      loop_size, x = 0, BigInt.new(1)

      until x == public_key
        loop_size += 1
        x = (x * 7) % 20201227
      end

      loop_size
    end

    def transform(subject, loop_size)
      result = BigInt.new(1)

      loop_size.times do
        result *= subject
        result %= 20201227
      end

      result
    end
  end
end
