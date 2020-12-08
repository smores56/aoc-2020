require "./day"

module Aoc
  class Day8 < Day
    def first(input)
      ops = input.map { |line| Operation.parse line }
      accumulator, finished = interpret ops
      accumulator
    end

    def second(input)
      original_ops = input.map { |line| Operation.parse line }
      
      (0...original_ops.size).each do |index|
        case original_ops[index][0]
        when Operation::Jmp
          modified_ops = original_ops
            .map_with_index { |pair, i| i == index ? {Operation::Nop, pair[1]} : pair }
          accumulator, finished = interpret modified_ops
          return accumulator if finished
        when Operation::Nop
          modified_ops = original_ops
            .map_with_index { |pair, i| i == index ? {Operation::Jmp, pair[1]} : pair }
          accumulator, finished = interpret modified_ops
          return accumulator if finished
        end
      end
      
      0
    end
    
    def interpret(ops)
      accumulator = 0
      index = 0
      visited = [] of Int32

      while (0...ops.size).covers? index
        return {accumulator, false} if visited.includes? index
        visited.push index

        op, arg = ops[index]
        case op
        when Operation::Nop
          index += 1
        when Operation::Acc
          accumulator += arg
          index += 1
        when Operation::Jmp
          index += arg
        end
      end

      {accumulator, index == ops.size && ops.last != Operation::Jmp}
    end

    enum Operation
      Nop
      Acc
      Jmp

      def self.parse(line)
        split = line.split

        arg = split[1].to_i
        op = case split[0]
             when "nop"
               Nop
             when "acc"
               Acc
             when "jmp"
               Jmp
             else
               nil
             end

        {op.not_nil!, arg}
      end
    end
  end
end
