require "./day"
require "big"

module Aoc
  class Day16 < Day
    def first(input)
      groups = input
        .chunk_while { |_line1, line2| !line2.empty? }
        .map { |group| group.select { |line| !line.empty? } }
        .to_a
      fields = groups[0].map { |line| Field.parse line }
      my_ticket = groups[1][1].split(',').map &.to_i
      other_tickets = groups[2][1..].map { |line| line.split(',').map &.to_i }

      other_tickets.sum do |values|
        values.find { |value| fields
          .all? { |field| !field.matches? value } } || 0
      end
    end

    def second(input)
      groups = input
        .chunk_while { |_line1, line2| !line2.empty? }
        .map { |group| group.select { |line| !line.empty? } }
        .to_a
      fields = groups[0].map { |line| Field.parse line }
      my_ticket = groups[1][1].split(',').map &.to_i
      other_tickets = groups[2][1..].map { |line| line.split(',').map &.to_i }

      valid_tickets = other_tickets.select do |values|
        !values.any? { |value| fields
          .all? { |field| !field.matches? value } }
      end

      valid_field_indices = fields.to_h do |field|
        matching_indices = (0...fields.size).select do |index|
          valid_tickets.all? { |ticket| field.matches? ticket[index] }
        end

        {field.@name.not_nil!, matching_indices}
      end

      field_order = {} of String => Int32
      until valid_field_indices.empty?
        field_name, indices = valid_field_indices.find { |_k, v| v.size == 1 } ||
                              raise "field order is ambiguous"

        index = indices.first
        field_order[field_name] = index

        valid_field_indices.delete field_name
        valid_field_indices.values.each { |idxs| idxs.delete index }
      end

      fields
        .compact_map { |field| field.@name.starts_with?("departure") ? field.@name : nil }
        .product { |field_name| BigInt.new my_ticket[field_order[field_name]] }
    end

    class Field
      def initialize(@name : String, @constraints : Array(Range(Int32, Int32)))
      end

      def self.parse(line)
        if md = line.match /^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$/
          constraints = [(md[2].to_i..md[3].to_i), (md[4].to_i..md[5].to_i)]
          Field.new md[1], constraints
        else
          raise "invalid field: #{line}"
        end
      end

      def matches?(value)
        @constraints.any? { |constraint| constraint.covers? value }
      end
    end
  end
end
