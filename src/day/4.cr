require "./day"

module Aoc
  class Day4 < Day
    def first(input)
      Passport.all_from_lines(input).count &.has_required_fields?
    end

    def second(input)
      Passport.all_from_lines(input).count &.is_valid?
    end

    class Passport
      def initialize(pairs)
        @byr = @iyr = @eyr = @hgt = @hcl = @ecl = @pid = @cid = nil.as(Nil | String)

        pairs.each do |pair|
          split = pair.split ':'
          key, value = split[0], split[1]

          case key
          when "byr"
            @byr = value
          when "iyr"
            @iyr = value
          when "eyr"
            @eyr = value
          when "hgt"
            @hgt = value
          when "hcl"
            @hcl = value
          when "ecl"
            @ecl = value
          when "pid"
            @pid = value
          when "cid"
            @cid = value
          end
        end
      end

      def self.all_from_lines(lines)
        lines
          .chunk_while { |_line1, line2| !line2.empty? }
          .map do |lines|
            Passport.new(
              lines
                .flat_map { |line| line.split(' ') }
                .select { |pair| !pair.empty? }
            )
          end
      end

      def has_required_fields?
        @byr && @iyr && @eyr && @hgt && @hcl && @ecl && @pid
      end

      def is_valid?
        constraints = [{@byr, 1920..2002}, {@iyr, 2010..2020}, {@eyr, 2020..2030}]
        constraints.each do |value, valid_range|
          if md = value.try &.match /^\d{4}$/
            return false unless valid_range.covers? md[0].to_i
          else
            return false
          end
        end

        if md = @hgt.try &.match /^(\d+)cm$/
          cm = md[1].to_i
          return false unless (150..193).covers? cm
        elsif md = @hgt.try &.match /^(\d+)in$/
          inches = md[1].to_i
          return false unless (59..76).covers? inches
        else
          return false
        end

        return false unless @hcl.try &.match /^#[0-9a-f]{6}$/

        eye_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        return false unless eye_colors.includes? (@ecl || "")

        return false unless @pid.try &.match /^\d{9}$/

        true
      end
    end
  end
end
