require "./day"

module Aoc
  class Day24 < Day
    def first(input)
      # map from coordinates to "is black"
      tiles = {} of Tuple(Int32, Int32) => Bool

      input.each do |line|
        coords = tile_coordinates line
        tiles[coords] = !(tiles[coords]? || false)
      end

      tiles.values.count true
    end

    def second(input)
      # map from coordinates to "is black"
      tiles = {} of Tuple(Int32, Int32) => Bool

      input.each do |line|
        coords = tile_coordinates line
        tiles[coords] = !(tiles[coords]? || false)
      end

      min_x, max_x, min_y, max_y = borders tiles
      100.times do
        min_x -= 1
        max_x += 1
        min_y -= 1
        max_y += 1

        new_tiles = {} of Tuple(Int32, Int32) => Bool

        (min_x..max_x).each do |x|
          (min_y..max_y).each do |y|
            coords = {x, y}
            is_black = tiles[coords]? || false
            black_neighbor_count = black_neighbors tiles, coords

            if is_black
              new_tiles[coords] = !(black_neighbor_count == 0 || black_neighbor_count > 2)
            else
              new_tiles[coords] = black_neighbor_count == 2
            end
          end
        end

        tiles = new_tiles
      end

      tiles.values.count true
    end

    def tile_coordinates(directions)
      x, y = 0, 0
      chars = directions.chars.to_a

      until chars.empty?
        case chars.shift
        when 'e'
          x += 1
        when 'w'
          x -= 1
        when 'n'
          y -= 1
          case chars.shift
          when 'e'
            x += 1
          when 'w'
            # pass
          end
        when 's'
          y += 1
          case chars.shift
          when 'e'
            # pass
          when 'w'
            x -= 1
          end
        end
      end

      {x, y}
    end

    def borders(tiles)
      tiles.keys.reduce({0, 0, 0, 0}) do |border, tile|
        x, y = tile
        min_x, max_x, min_y, max_y = border

        {Math.min(x, min_x), Math.max(x, max_x),
         Math.min(y, min_y), Math.max(y, max_y),
        }
      end
    end

    def black_neighbors(tiles, coords)
      x, y = coords
      neighbors = [
        {x + 1, y}, {x, y + 1}, {x - 1, y + 1},
        {x - 1, y}, {x, y - 1}, {x + 1, y - 1},
      ]

      neighbors.count { |coords| tiles[coords]? || false }
    end
  end
end
