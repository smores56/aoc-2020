require "./day"

module Aoc
  class Day11 < Day
    def first(input)
      map = SeatMap.new input
      final_map = map.converge 4 { |r, c, m| m.naive_adjacency_count r, c }
      final_map.num_filled
    end

    def second(input)
      map = SeatMap.new input
      final_map = map.converge 5 { |r, c, m| m.ray_tracing_adjacency_count r, c }
      final_map.num_filled
    end

    class SeatMap
      seats : Array(Array(Seat))

      enum Seat
        Floor
        Filled
        Empty
      end

      def initialize(lines : Array(String))
        @seats = lines.map do |line|
          line.chars.map do |char|
            case char
            when '.'
              Seat::Floor
            when 'L'
              Seat::Empty
            when '#'
              Seat::Filled
            else
              raise "Invalid seat seat: #{char}"
            end
          end
        end
      end

      def initialize(seats : Array(Array(Seat)))
        @seats = seats
      end

      def converge(crowding_point, &count_adjacent_seats : Int32, Int32, SeatMap -> Int32)
        next_map = tick crowding_point, &count_adjacent_seats

        while self != next_map
          @seats = next_map.@seats
          next_map = next_map.tick crowding_point, &count_adjacent_seats
        end

        next_map
      end

      def num_filled
        @seats.sum { |row| row.count { |seat| seat == Seat::Filled } }
      end

      def tick(crowding_point, & : Int32, Int32, SeatMap -> Int32)
        new_seats = (0...(@seats.size)).map do |row|
          (0...(@seats[0].size)).map do |column|
            case @seats[row][column]
            when Seat::Floor
              Seat::Floor
            when Seat::Filled
              (crowding_point > yield row, column, self) ? Seat::Filled : Seat::Empty
            when Seat::Empty
              (0 == yield row, column, self) ? Seat::Filled : Seat::Empty
            else
              Seat::Floor
            end
          end
        end

        SeatMap.new new_seats
      end

      def naive_adjacency_count(row, column)
        adjacent_locations = [
          {row, column - 1},
          {row, column + 1},
          {row + 1, column - 1},
          {row + 1, column + 1},
          {row - 1, column - 1},
          {row - 1, column + 1},
          {row + 1, column},
          {row - 1, column},
        ]
        valid_locations = adjacent_locations
          .select { |r, c| (0...(@seats.size)).covers?(r) && (0...(@seats[0].size)).covers?(c) }

        valid_locations.count { |r, c| @seats[r][c] == Seat::Filled }
      end

      def ray_tracing_adjacency_count(row, column)
        directions = [
          {0, 1},
          {0, -1},
          {1, 1},
          {1, -1},
          {-1, 1},
          {-1, -1},
          {1, 0},
          {-1, 0},
        ]
        
        directions.count do |up, right|
          curr_row, curr_column = row + up, column + right
          filled = false

          while (0...@seats.size).covers?(curr_row) && (0...(@seats[0].size)).covers?(curr_column)
            seat = @seats[curr_row]?.try &.[curr_column]?
            filled = true if seat == Seat::Filled
            
            curr_row, curr_column = if seat == Seat::Floor
              {curr_row + up, curr_column + right}
            else
              {-1, -1}
            end
          end 
          
          filled
        end
      end

      def ==(other)
        @seats.zip(other.@seats).all? do |row1, row2|
          row1.zip(row2).all? { |seat1, seat2| seat1 == seat2 }
        end
      end

      def inspect(io)
        @seats.each do |row|
          row.each do |seat|
            case seat
            when Seat::Floor
              io << '.'
            when Seat::Empty
              io << 'L'
            when Seat::Filled
              io << '#'
            end
          end

          io << '\n'
        end
      end
    end
  end
end
