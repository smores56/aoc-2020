require "./day"

module Aoc
  class Day17 < Day
    def first(input)
      # field = CubeField.new input
      field = CubeField.new [".#.", "..#", "###"]

      p field.@cubes

      field = field.simulate

      p field.@cubes

      # 6.times do
      #   field = field.simulate
      #   p field.num_active
      # end

      field.num_active
    end

    def second(input)
      input.size # TODO
    end

    class CubeField
      def initialize(@cubes : Hash({Int32, Int32, Int32}, Bool))
      end

      def self.new(lines)
        new(lines
          .map_with_index { |line, row| line
            .chars
            .map_with_index { |ch, col| { {col, row, 0}, ch == '#' } } }
          .flatten
          .to_h)
      end

      def set_active(coords, is_active)
        @cubes[coords] = is_active
      end

      def active?(coords)
        @cubes[coords]? || false
      end

      def num_active
        @cubes.values.count true
      end

      def active_neighbors(coords)
        x, y, z = coords

        (-1..1).sum do |x_offset|
          (-1..1).sum do |y_offset|
            (-1..1).count do |z_offset|
              new_coords = {x + x_offset, y + y_offset, z + z_offset}
              new_coords != {0, 0, 0} && active? new_coords
            end
          end
        end
      end

      def simulate
        new_field = CubeField.new({} of {Int32, Int32, Int32} => Bool)
        min_x, max_x, min_y, max_y, min_z, max_z = boundaries

        ((min_x - 1)..(max_x + 1)).each do |x|
          ((min_y - 1)..(max_y + 1)).each do |y|
            ((min_z - 1)..(max_z + 1)).each do |z|
              coords = {x, y, z}
              active_count = active_neighbors coords

              if active? coords
                new_field.set_active coords, (active_count == 2 || active_count == 3)
              else
                new_field.set_active coords, (active_count == 3)
              end
            end
          end
        end

        new_field
      end

      def boundaries
        @cubes.keys.reduce({0, 0, 0, 0, 0, 0}) do |bounds, coords|
          x, y, z = coords
          min_x, max_x, min_y, max_y, min_z, max_z = bounds

          {Math.min(x, min_x), Math.max(x, max_x),
           Math.min(y, min_y), Math.max(y, max_y),
           Math.min(z, min_z), Math.max(z, max_z),
          }
        end
      end
    end
  end
end
