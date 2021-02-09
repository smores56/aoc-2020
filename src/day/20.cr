require "./day"

module Aoc
  class Day20 < Day
    def first(input)
      images = {} of Int32 => Image
      while input.size > 0
        empty_index = input.index(&.empty?) || input.size

        image_id = input.first.match(/\d+/).not_nil![0].to_i
        image = Image.new input[...(empty_index - 1)]
        images[image_id] = image

        input = input[(empty_index + 1)..]
      end

      first_id, first_image = images.shift
      collage = {first_id => first_image}

      # until images.empty?
      #   next_id, next_image, orientation = images
      #     .each
      #     .compact_map do |id_to_check|
      #       images.do |image_id, image|
      #       end
      #     end
      # end

      input.size # TODO
    end

    def take_fitting_image(images, collage)
      # images.each_key do |id|
      #   image = images[id]
      #   collage.each do |collage_id, fitted_image|
      #     Orientation::ALL.each do |orientation|
      #       if fitted_image.neighbor(orientation).nil? &&
      #         fitted_image.border(orientation) == image(orientation.opposite)
      #           return {id, image,
      #       end
      #     end
      #   end
      # end
      # images.each do |image_id, image|

      # end
    end

    def second(input)
      input.size # TODO
    end

    enum Orientation
      Top
      Bottom
      Left
      Right

      def self.all(&)
        yield Top
        yield Bottom
        yield Left
        yield Right
      end

      def turn(orientation)
        case orientation
        when Top
          self
        when Left
          self.turn_left
        when Bottom
          self.turn_left.turn_left
        when Right
          self.turn_left.turn_left.turn_left
        end
      end

      def turn_left
        case self
        when Top
          Left
        when Left
          Bottom
        when Bottom
          Right
        when Right
          Top
        end
      end

      def opposite
        case self
        when Top
          Bottom
        when Bottom
          Top
        when Left
          Right
        when Right
          Left
        end
      end
    end

    class Collage
      def initialize(@images : Hash(Int32, Image))
        @neighbors = {} of Int32 => Hash(Orientation, Int32)
      end

      # def set_neighbor(fitted_id, child_id,
    end

    class Image
      def initialize(@pixels : Array(Array(Bool)))
      end

      def self.new(pixels : Array(String))
        new(pixels.map { |line| line
          .chars.map { |ch| ch == '#' } })
      end

      def flip_vertically!
        @pixels = @pixels.reverse!
      end

      def flip_horizontally!
        @pixels.each { |row| row.reverse! }
      end

      def turn!(orientation)
        return if orientation == Orientation::Top

        side_length = @pixels.size
        @pixels = (0...side_length).map do |row|
          (0...side_length).map do |column|
            case orientation
            when Orientation::Bottom
              @pixels[side_length - row - 1][side_length - column - 1]
            when Orientation::Left
              @pixels[side_length - column - 1][row]
            when Orientation::Right
              @pixels[column][side_length - row - 1]
            else
              raise "invalid orientation found while turning picture: #{orientation}"
            end
          end
        end
      end

      def border(orientation)
        case orientation
        when Orientation::Top
          @pixels.first
        when Orientation::Bottom
          @pixels.last
        when Orientation::Right
          @pixels.map { |row| row.last }
        when Orientation::Left
          @pixels.map { |row| row.first }
        end
      end
    end
  end
end
