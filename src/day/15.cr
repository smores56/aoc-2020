require "./day"

module Aoc
  class Day15 < Day
    def first(input)
      starting_nums = input[0].split(',').map &.to_i
      memory_game starting_nums, 2020
    end

    def second(input)
      starting_nums = input[0].split(',').map &.to_i
      memory_game starting_nums, 30000000
    end

    def memory_game(starting_nums, num_to_find)
      num = starting_nums.last
      previous_indices = starting_nums
        .each_with_index
        .to_h { |num, index| {num, {index, nil.as(Nil | Int32)}} }

      (0...num_to_find).skip(starting_nums.size).each do |index|
        last_index, prior_index = previous_indices[num]
        if prior_index
          num = last_index - prior_index
        else
          num = 0
        end

        new_prior_index = previous_indices[num]?.try &.[0]
        previous_indices[num] = {index, new_prior_index}
      end

      num
    end
  end
end
