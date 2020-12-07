require "./day"

module Aoc
  class Day5 < Day
    def first(input)
      input.map { |pass| BoardingPass.new(pass).id }.max
    end

    def second(input)
      sorted_ids = input.map { |pass| BoardingPass.new(pass).id }.sort

      my_id_index = 0
      while sorted_ids[my_id_index] + 1 == sorted_ids[my_id_index + 1]
        my_id_index += 1
      end

      sorted_ids[my_id_index] + 1
    end

    class BoardingPass
      @row : Int32
      @column : Int32

      def initialize(partitions)
        @row = (0..6)
          .map { |i| partitions[i]? == 'B' ? (2 ** (6 - i)) : 0 }
          .sum
        @column = (0..2)
          .map { |i| partitions[i + 7]? == 'R' ? (2 ** (2 - i)) : 0 }
          .sum
      end

      def id
        @row * 8 + @column
      end
    end
  end
end
