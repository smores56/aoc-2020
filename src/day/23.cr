require "./day"
require "big"

module Aoc
  class Day23 < Day
    def first(input)
      # cups = input[0].chars.map &.to_i
      cups = [3, 8, 9, 1, 2, 5, 4, 6, 7]
      cup_range = (cups.min..cups.max)
      current = cups.first

      100.times do
        current = cycle_cups current, cups, cup_range
        puts "current: #{current}, cups: #{cups}"
      end

      index_of_1 = cups.index(1).not_nil!
      (1...cups.size)
        .map { |i| cups[(index_of_1 + i) % cups.size].to_s }
        .join
    end

    def second(input)
      0
      # cups = input[0].chars.map &.to_i
      # cups.concat ((cups.max + 1)..1000000)
      # cup_range = 1..1000000
      # current = cups.first

      # 10000000.times do
      #   current = cycle_cups current, cups, cup_range
      # end

      # index_of_1 = cups.index(1).not_nil!
      # first = cups[(index_of_1 + 1) % cups.size]
      # second = cups[(index_of_1 + 2) % cups.size]

      # BigInt.new(first) * BigInt.new(second)
    end

    def cycle_cups(current, cups, cup_range)
      current_index = cups.index(current).not_nil!
      picked_up = 3.times.map do
        pick_up_index = (current_index + 1) % cups.size
        current_index -= 1 if pick_up_index < current_index
        cups.delete_at pick_up_index
      end
      picked_up = picked_up.to_a

      destination = current - 1
      until cup_range.covers?(destination) && !picked_up.includes?(destination)
        destination -= 1
        destination = cup_range.end if destination < cup_range.begin
      end

      dest_index = cups.index(destination).not_nil!
      picked_up.each_with_index do |cup, index|
        insert_index = dest_index + 1 + index
        cups.insert insert_index, cup
        current_index += 1 if insert_index < current_index
      end

      cups[(current_index + 1) % cups.size]
    end
  end
end
