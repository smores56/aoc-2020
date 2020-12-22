require "./day"
require "big"

module Aoc
  class Day18 < Day
    def first(input)
      input.sum { |line| Expression.parse(line.strip)[0].eval_simple }
    end

    def second(input)
      input.sum { |line| Expression.parse(line.strip)[0].eval_complex }
    end

    enum Operation
      Add
      Multiply

      def self.parse(input)
        case input
        when "*"
          Multiply
        when "+"
          Add
        else
          raise "invalid operation: #{input}"
        end
      end
    end

    abstract class Expression
      abstract def eval_simple : BigInt
      abstract def eval_complex : BigInt

      def self.parse(line)
        expressions, operations = [] of Expression, [] of Operation

        while true
          case line
          when /^\(/
            inner_expression, line = Expression.parse(line[1..])
            expressions.push inner_expression
          when /^\)\s*/
            expression = ComplexExpression.new expressions, operations
            return {expression, line[($~[0].size)..]}
          when /^(\d+)\s*/
            expressions.push Scalar.new(BigInt.new $~[1].strip)
            line = line[($~[0].size)..]
          when /^(\*|\+)\s*/
            operations.push(Operation.parse $~[1].strip)
            line = line[($~[0].size)..]
          else
            expression = ComplexExpression.new expressions, operations
            return {expression, line}
          end
        end
      end
    end

    class Scalar < Expression
      def initialize(@value : BigInt)
      end

      def eval_simple : BigInt
        @value
      end

      def eval_complex : BigInt
        @value
      end
    end

    class ComplexExpression < Expression
      def initialize(@expressions : Array(Expression), @operations : Array(Operation))
      end

      def eval_simple : BigInt
        return BigInt.new(0) if @expressions.empty?

        result = @expressions[0].eval_simple
        @expressions[1..].zip(@operations) do |expr, op|
          case op
          when Operation::Multiply
            result *= expr.eval_simple
          when Operation::Add
            result += expr.eval_simple
          end
        end

        result
      end

      def eval_complex : BigInt
        return BigInt.new(0) if @expressions.empty?

        evals = @expressions.map { |expr| expr.eval_complex }
        ops = @operations.dup

        while add_index = ops.index { |op| op == Operation::Add }
          evals = [
            evals[0...add_index],
            (evals[add_index] + evals[add_index + 1]),
            evals[(add_index + 2)..],
          ].flatten
          ops = [
            ops[0...add_index],
            ops[(add_index + 1)..],
          ].flatten
        end

        evals.product
      end
    end
  end
end
