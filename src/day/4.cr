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
        return false unless has_required_fields?

        return false unless (@byr || "").match(/\d{4}/) && (1920..2002).includes? (@byr || 0).to_i
        return false unless (@iyr || "").match(/\d{4}/) && (2010..2020).includes? (@iyr || 0).to_i
        return false unless (@eyr || "").match(/\d{4}/) && (2020..2030).includes? (@eyr || 0).to_i

        if md = (@hgt || "").match /(\d+)cm/
          return false unless (150..193).includes? md[1].to_i
        elsif md = (@hgt || "").match /(\d+)in/
          return false unless (59..76).includes? md[1].to_i
        else
          return false
        end

        return false unless (@hcl || "").match /\#[0-9a-f]{6}/
        return false unless ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].includes? @ecl
        return false unless (@pid || "").match /\d{9}/

        true
      end

      def inspect(io)
        [{@byr, "byr"}, {@iyr, "iyr"}, {@eyr, "eyr"}, {@hgt, "hgt"},
         {@hcl, "hcl"}, {@ecl, "ecl"}, {@pid, "pid"}, {@cid, "cid"},
        ].each do |val, name|
          io << name << ": " << (val || "nil") << ", "
        end
      end
    end
  end
end
