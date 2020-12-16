require "./day"

module Aoc
  class Day14 < Day
    def first(input)
      registers = {} of UInt64 => UInt64
      mask = 36.times.map { |_| nil.as(Nil | Bool) }.to_a

      input.each do |instruction|
        if md = instruction.match /mask = ([X01]{36})/
          mask = parse_mask md[1]
        elsif md = instruction.match /mem\[(\d+)\] = (\d+)/
          index, value = md[1].to_u64, md[2].to_u64
          registers[index] = (0...36).sum do |i|
            case mask[35 - i]
            when nil
              value.bit(i).to_u64 << i
            when true
              1_u64 << i
            when false
              0_u64
            else
              raise "invalid mask bit"
            end
          end
        else
          raise "invalid instruction: #{instruction}"
        end
      end

      registers.values.sum
    end

    def second(input)
      registers = {} of UInt64 => UInt64
      mask = 36.times.map { |_| nil.as(Nil | Bool) }.to_a

      input.each do |instruction|
        if md = instruction.match /mask = ([X01]{36})/
          mask = parse_mask md[1]
        elsif md = instruction.match /mem\[(\d+)\] = (\d+)/
          index, value = md[1].to_u64, md[2].to_u64
          address_set = (0...36).map do |i|
            case mask[i]
            when true
              true
            when false
              index.bit(35 - i) == 1
            else
              nil
            end
          end

          each_address address_set do |address|
            registers[address] = value
          end
        else
          raise "invalid instruction: #{instruction}"
        end
      end

      registers.values.sum
    end

    def parse_mask(mask_chars)
      mask_chars.chars.map do |char|
        case char
        when 'X'
          nil
        when '0'
          false
        when '1'
          true
        else
          raise "invalid mask character"
        end
      end
    end

    def each_address(address_set, &func : UInt64 ->)
      each_address 0, 0_u64, address_set, &func
    end

    def each_address(index, address, address_set, &func : UInt64 ->)
      if index == 36
        yield address
      else
        bit = address_set[35 - index]
        if bit.is_a?(Bool)
          each_address(index + 1, set_bit_to(bit, address, index), address_set, &func)
        else
          each_address(index + 1, set_bit_to(true, address, index), address_set, &func)
          each_address(index + 1, set_bit_to(false, address, index), address_set, &func)
        end
      end
    end

    def set_bit_to(is_set, address, index)
      if is_set
        address | (1_u64 << index)
      else
        full_mask = (1_u64 << 36) - 1
        address & (full_mask & ~(1_u64 << index))
      end
    end
  end
end
