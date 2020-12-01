require "./day"

module Aoc
  class Day1 < Day
    def first(input)
      pair = input.map(&.to_i)
        .combinations(2)
        .find(if_none: [0, 0]) { |p| p[0] + p[1] == 2020 }

      pair[0] * pair[1]
    end

    def second(input)
      triplet = input.map(&.to_i)
        .combinations(3)
        .find(if_none: [0, 0, 0]) { |t| t[0] + t[1] + t[2] == 2020 }

      triplet[0] * triplet[1] * triplet[2]
    end
  end
end
