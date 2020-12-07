require "./day"

module Aoc
  class Day6 < Day
    def first(input)
      answers = input.each
        .chunk_while { |_line1, line2| !line2.empty? }
        .map { |lines| lines.select { |line| !line.empty? } }

      answers
        .map { |group| group.join.chars.group_by { |ch| ch }.size }
        .sum
    end

    def second(input)
      answers = input.each
        .chunk_while { |_line1, line2| !line2.empty? }
        .map { |lines| lines.select { |line| !line.empty? } }

      num_all_yes = answers.map do |group|
        chars = group.join.chars
        unique_chars = chars.uniq
        
        chars.uniq.count { |ch| group.all? { |answer| answer.includes? ch } }
      end
      
      num_all_yes.sum
    end
  end
end
