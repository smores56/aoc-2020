require "./day"
require "big"

module Aoc
  class Day9 < Day
    def first(input)
      nums = input.map { |line| BigInt.new line }
      find_wrong_number nums, 25
    end

    def second(input)
      nums = input.map { |line| BigInt.new line }
      wrong_number = find_wrong_number nums, 25

      (0...nums.size).each do |start|
        sum = 0
        (start...nums.size).each do |finish|
          sum += nums[finish]
          if sum == wrong_number
            range = nums[start...finish]
            return range.min + range.max
          end
        end
      end
    end

    def find_wrong_number(nums, preamble_size)
      (preamble_size..).each do |index|
        preamble = nums[(index - preamble_size)...(index)]
        num = nums[index]

        can_sum = preamble.combinations(2).find { |pair| pair.sum == num }
        return num unless can_sum
      end
    end
  end
end
