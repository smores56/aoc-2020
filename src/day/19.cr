require "./day"

module Aoc
  class Day19 < Day
    def first(input)
      empty_index = input.index { |line| line.empty? }.not_nil!
      rules = input[0...empty_index].to_h { |line| Rule.parse(line) }
      lines = input[(empty_index + 1)..]

      lines.count do |line|
        if rest = rules[0].find_match line, rules
          rest.empty?
        else
          false
        end
      end
    end

    def second(input)
      empty_index = input.index { |line| line.empty? }.not_nil!
      rules = input[0...empty_index].to_h { |line| Rule.parse(line) }
      lines = input[(empty_index + 1)..]

      rules[8] = CompoundRule.new(
        (1..100).map { |i| i.times.map { 42 }.to_a })
      rules[11] = CompoundRule.new(
        (1..100).map { |i| i.times.map { 42 }.chain(i.times.map { 31 }).to_a })

      lines.count do |line|
        # (1..100)
        if rest = rules[0].find_match line, rules
          rest.empty?
        else
          false
        end
      end
    end

    abstract class Rule
      abstract def find_match(line : String, rules : Hash(Int32, Rule)) : String | Nil

      def self.parse(line)
        split = line.split ": "
        index, rest = split[0].to_i, split[1]

        if md = rest.match /"(\w+)"/
          return {index, StringRule.new(md[1])}
        else
          sub_rule_sets = rest.split(" | ").map { |set| set.split.map { |id| id.to_i } }
          return {index, CompoundRule.new(sub_rule_sets)}
        end
      end
    end

    class StringRule < Rule
      def initialize(@str : String)
      end

      def find_match(line, rules) : String | Nil
        line.starts_with?(@str.not_nil!) ? line[(@str.size)..] : nil
      end
    end

    class CompoundRule < Rule
      def initialize(@sub_rule_sets : Array(Array(Int32)))
      end

      def find_match(line, rules) : String | Nil
        @sub_rule_sets
          .each
          .compact_map { |ids| find_sub_match ids, line, rules }
          .first?
      end

      def find_sub_match(sub_rule_ids, line, rules)
        sub_rule_ids.each do |id|
          sub_rule = rules[id]? || raise "missing rule referenced: #{id}"
          if rest_of_line = sub_rule.find_match line, rules
            line = rest_of_line
          else
            return nil
          end
        end

        line
      end
    end
  end
end

#   class Matches
#     include Iterator(String)

#     def initialize(@sub_rule_sets : Array(Array(Int32)), @line : String, @rules : Hash(Int32, Rule))
#       @set_index = 0
#       @sub_matches = [] of Tuple(Rule, Iterator(String), String | Nil)
#     end

#     def next
#       while true
#         sub_rule_ids = @rule.sub_rule_sets[@set_index]? || stop
#         if @sub_matches.size == sub_rule_ids.size

#         end

#         if sub_matches = @sub_matches
#           sub_matches.each_with_index do |rule, matches, rest|
#         end
#         sub_rule_ids = @rule.sub_rule_sets[@set_index]? || stop
#         sub_rule_ids.each_with_index do |sub_rule_id, sub_index|
#           sub_rule = @rules[id]? || raise "missing rule referenced: #{id}"

#         end

#         if sub = @sub_matches
#           n = sub.next
#           return n if n != Iterator::Stop::INSTANCE

#           @sub_matches = nil
#         end

#         sub_rule_ids = @rule.sub_rule_sets[@set_index]? || stop
#         @sub_matches = match_sub_rule sub_rule_ids
#         @set_index += 1
#       end
#     end

#     def match_sub_rule(sub_rule_ids)
#       line = @line

#       sub_rule_ids.each do |id|
#         sub_rule = @rules[id]? || raise "missing rule referenced: #{id}"
#         if rest_of_line = sub_rule.find_match line, @rules
#           line = rest_of_line
#         else
#           return nil
#         end
#       end

#       line
#     end
#   end
# end
#   end
# end
