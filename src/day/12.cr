require "./day"

module Aoc
  class Day12 < Day
    def first(input)
      directions = input
        .map { |line| {Direction.parse(line[0]), line[1..].to_i} }
      x, y, heading = 0, 0, 0

      directions.each do |direction, distance|
        case direction
        when Direction::North
          y += distance
        when Direction::South
          y -= distance
        when Direction::East
          x += distance
        when Direction::West
          x -= distance
        when Direction::Left
          heading = (heading + distance) % 360
        when Direction::Right
          heading = (heading - distance) % 360
        when Direction::Forward
          case heading
          when 0
            x += distance
          when 90
            y += distance
          when 180
            x -= distance
          when 270
            y -= distance
          end
        end
      end

      x.abs + y.abs
    end

    def second(input)
      directions = input
        .map { |line| {Direction.parse(line[0]), line[1..].to_i} }
      ship_x, ship_y = 0, 0
      waypoint_x, waypoint_y = 10, 1

      directions.each do |direction, distance|
        case direction
        when Direction::North
          waypoint_y += distance
        when Direction::South
          waypoint_y -= distance
        when Direction::East
          waypoint_x += distance
        when Direction::West
          waypoint_x -= distance
        when Direction::Left, Direction::Right
          case ((direction == Direction::Left) ? distance : -distance) % 360
          when 90
            waypoint_x, waypoint_y = -waypoint_y, waypoint_x
          when 180
            waypoint_x, waypoint_y = -waypoint_x, -waypoint_y
          when 270
            waypoint_x, waypoint_y = waypoint_y, -waypoint_x
          end
        when Direction::Forward
          ship_x += waypoint_x * distance
          ship_y += waypoint_y * distance
        end
      end

      ship_x.abs + ship_y.abs
    end

    enum Direction
      North
      South
      East
      West
      Left
      Right
      Forward

      def self.parse(char)
        case char
        when 'N'
          North
        when 'S'
          South
        when 'E'
          East
        when 'W'
          West
        when 'L'
          Left
        when 'R'
          Right
        when 'F'
          Forward
        else
          raise "Invalid direction: #{char}"
        end
      end
    end
  end
end
