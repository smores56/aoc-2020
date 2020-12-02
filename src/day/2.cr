require "./day"

module Aoc
  class Day2 < Day
    class Constraint
      def initialize(@first : Int32, @second : Int32, @character : Char)
      end

      def self.parse(str : String)
        if data = str.match /(\d+)-(\d+) ([a-z])/
          Constraint.new data[1].to_i, data[2].to_i, data[3].char_at(0)
        else
          nil
        end
      end

      def self.parse_with_password(str : String)
        split = str.split ": "
        if constraint = Constraint.parse split[0]
          password = split[1]? || ""
          {constraint, password}
        else
          nil
        end
      end
    end

    def first(input)
      input
        .map { |i| Constraint.parse_with_password i }
        .compact
        .count do |constraint, password|
          count = password.chars.count { |c| c == constraint.@character }
          count >= constraint.@first && count <= constraint.@second
        end
    end

    def second(input)
      input
        .map { |i| Constraint.parse_with_password i }
        .compact
        .count do |constraint, password|
          first = password[constraint.@first - 1]? == constraint.@character
          second = password[constraint.@second - 1]? == constraint.@character
          first != second
        end
    end
  end
end
