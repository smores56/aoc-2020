require "./day"
require "big"

module Aoc
  class Day13 < Day
    def first(input)
      earliest = input[0].to_i
      bus_ids = input[1]
        .strip
        .split(',')
        .map { |i| i == "x" ? nil : i.to_i }
        .compact

      bus_id, wait_time = bus_ids
        .map { |id| {id, -earliest % id} }
        .min_by { |id, wt| wt }

      bus_id * wait_time
    end

    def second(input)
      bus_ids = input[1]
        .strip
        .split(',')
        .map { |i| i == "x" ? nil : BigInt.new i }
      constraints = bus_ids
        .map_with_index { |id, index| id ? {id, -index % id} : nil }
        .compact

      id_product = bus_ids.compact.product
      timestamp = constraints.sum do |id, index|
        inv = inverse(id_product // id, id)
        (id_product // id) * index * inv
      end

      timestamp % id_product
    end

    def inverse(a, n)
      t, new_t, r, new_r = 0, 1, n, a

      while new_r != 0
        quotient = r // new_r
        t, new_t = new_t, (t - quotient * new_t)
        r, new_r = new_r, (r - quotient * new_r)
      end

      raise "a is not invertible" if r > 1

      t < 0 ? (t + n) : t
    end
  end
end
