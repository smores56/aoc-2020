require "./day"
require "big"

module Aoc
  class Day3 < Day
    def trees_on_path(map_rows, down, over)
      width = map_rows[0].size
      count, x, y = 0, 0, 0

      while true
        x += over
        y += down

        break if y >= map_rows.size

        count += 1 if map_rows[y][x % width] == '#'
      end

      count
    end

    def first(input)
      trees_on_path(input, 1, 3)
    end

    def second(input)
      paths = [{1, 1}, {1, 3}, {1, 5}, {1, 7}, {2, 1}]

      paths
        .map { |down, over| BigInt.new trees_on_path(input, down, over) }
        .reduce 1 { |prod, i| prod * i }
    end
  end
end
