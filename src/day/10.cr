require "./day"

module Aoc
  class Day10 < Day
    def first(input)
      adapters = input.map &.to_i
      adapters.push 0, (adapters.max + 3)
      adapters.sort!

      diff1, diff3 = 0, 0
      adapters.each_cons_pair do |a, b|
        if b - a == 1
          diff1 += 1
        else
          diff3 += 1
        end
      end

      diff1 * diff3
    end

    def second(input)
      adapters = input.map { |line| BigInt.new line }
      adapters.push (BigInt.new 0), (BigInt.new (adapters.max + 3))
      adapters.sort!

      num_paths = Array.new(adapters.max + 1, BigInt.new 0)
      num_paths[0] = BigInt.new 1
      num_paths[1] = BigInt.new(adapters.includes?(1) ? 1 : 0)
      num_paths[2] = num_paths[1] + 1

      (3..adapters.max)
        .select { |a| adapters.includes? a }
        .each do |adapter|
          num_paths[adapter] = num_paths[(adapter - 3)..(adapter - 1)].sum
        end

      num_paths.last
    end
  end
end
