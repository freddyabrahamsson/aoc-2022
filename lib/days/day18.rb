# typed: strict
# frozen_string_literal: true

require_relative "day"
require "set"

module Days
  ##
  # Day 18
  class Day18 < Day
    class Grid
      extend T::Sig

      sig { params(lines: T::Array[String]).void }
      def initialize(lines)
        @droplets = T.let(Set.[], T::Set[[Integer, Integer, Integer]])
        lines.each do |line|
          coords = line.strip.split(",").map(&:to_i)
          @droplets.add([coords.fetch(0), coords.fetch(1), coords.fetch(2)])
        end
        @min_corner = T.let([0, 0, 0], [Integer, Integer, Integer])
        @max_corner = T.let([0, 0, 0], [Integer, Integer, Integer])
        set_min
        set_max
      end

      sig { returns(Integer) }
      def surface_area
        area = 0
        @droplets.each do |drop|
          neighbours(drop).each { |n| area += 1 unless @droplets.include?(n) }
        end
        area
      end

      sig { returns(Integer) }
      def exposed_surface
        area = 0
        visited = T.let(Set.[], T::Set[[Integer, Integer, Integer]])
        search_q = T.let([@min_corner], T::Array[[Integer, Integer, Integer]])

        until search_q.empty?
          curr_cube = T.must_because(search_q.pop) { "Loop condition is non-empty queue." }
          if @droplets.include?(curr_cube)
            area += 1
            next
          end
          next if visited.include?(curr_cube)

          visited.add(curr_cube)
          neighbours(curr_cube).each { |n| search_q.push n if in_the_cube n }
        end
        area
      end

      private

      sig { params(coord: [Integer, Integer, Integer]).returns(T::Boolean) }
      def in_the_cube(coord)
        (@min_corner[0]..@max_corner[0]).include?(coord[0]) &&
          (@min_corner[1]..@max_corner[1]).include?(coord[1]) &&
          (@min_corner[2]..@max_corner[2]).include?(coord[2])
      end

      sig { params(coord: [Integer, Integer, Integer]).returns(T::Array[[Integer, Integer, Integer]]) }
      def neighbours(coord)
        x = coord[0]
        y = coord[1]
        z = coord[2]
        [[x + 1, y, z], [x - 1, y, z], [x, y + 1, z], [x, y - 1, z], [x, y, z + 1], [x, y, z - 1]]
      end

      sig { void }
      def set_min
        @min_corner = [T.must(@droplets.map { |x, _, _| x }.min) - 1,
                       T.must(@droplets.map { |_, y, _| y }.min) - 1,
                       T.must(@droplets.map { |_, _, z| z }.min) - 1]
      end

      sig { void }
      def set_max
        @max_corner = [T.must(@droplets.map { |x, _, _| x }.max) + 1,
                       T.must(@droplets.map { |_, y, _| y }.max) + 1,
                       T.must(@droplets.map { |_, _, z| z }.max) + 1]
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 18.
    #
    # @return the answer to part a, day 18.
    def part_a
      g = Grid.new(@input_lines)
      g.surface_area
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 18.
    #
    # @return the answer to part B, day 18.
    def part_b
      g = Grid.new(@input_lines)
      g.exposed_surface
    end
  end
end
