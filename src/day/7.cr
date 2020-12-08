require "./day"

module Aoc
  class Day7 < Day
    def first(input)
      rules = parse_bag_rules(input)

      rules.count do |style, children|
        can_hold = false
        to_visit = children.keys
        visited = [] of String

        while visiting = to_visit.pop?
          if visiting == "shiny gold"
            can_hold = true
            break
          end

          visited.push visiting
          to_visit.concat rules[visiting].keys.reject { |k| visited.includes? k }
        end

        can_hold
      end
    end

    def second(input)
      rules = parse_bag_rules(input)
      inner_bag_count("shiny gold", rules) - 1
    end

    def inner_bag_count(style, rules) : Int32
      1 + rules[style].map { |ch_style, count| count * inner_bag_count(ch_style, rules) }.sum
    end

    def parse_bag_rules(lines)
      lines.to_h do |line|
        first_split = line[..-2].split " bags contain "
        style, rest = first_split[0].strip, first_split[1]

        children = if rest.starts_with? "no other bag"
                     {} of String => Int32
                   else
                     rest.split(", ").to_h do |child|
                       split = child.split limit: 2
                       count = split[0].to_i
                       child_style = split[1].split("bag")[0]

                       {child_style.strip, count}
                     end
                   end

        {style, children}
      end
    end
  end
end
