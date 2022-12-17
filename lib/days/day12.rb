# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 12
  class Day12 < Day
    START_STRING = "S"
    END_STRING = "E"

    ##
    # A coordinate
    class Coordinate < T::Struct
      extend T::Sig

      prop :x, Integer
      prop :y, Integer
    end

    ##
    # A Gridpoint
    class Gridpoint < T::Struct
      extend T::Sig

      prop :char, String
      prop :shortest_dist, T.nilable(Integer)

      sig { returns(Integer) }
      def height
        return "z".ord if char.eql?(END_STRING)
        return "a".ord if char.eql?(START_STRING)

        char.ord
      end

      sig { params(dist: Integer).void }
      def record_dist(dist)
        @shortest_dist = dist
      end
    end

    ##
    # A grid
    class Grid
      extend T::Sig

      sig { returns(T::Array[T::Array[Gridpoint]]) }
      attr_reader :grid

      sig { params(lines: T::Array[String]).void }
      def initialize(lines)
        @grid = T.let([], T::Array[T::Array[Gridpoint]])
        @exploration_queue = T.let([], T::Array[Coordinate])
        build_grid(lines)
      end

      sig { void }
      def explore
        until @exploration_queue.empty?
          next_p = T.must(@exploration_queue.shift)
          step_explore_from(next_p.x, next_p.y)
        end
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Array[Coordinate]) }
      def step_explore_from(x_c, y_c)
        this_dist = T.must(T.must(@grid[y_c])[x_c]).shortest_dist
        explorable_neighbours(x_c, y_c).each do |nabo|
          T.must(@grid[nabo.y])[nabo.x]&.shortest_dist = this_dist&.+ 1
          @exploration_queue << nabo
        end
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Array[Coordinate]) }
      def explorable_neighbours(x_c, y_c)
        neighbours = x_neighbours(x_c, y_c) + y_neighbours(x_c, y_c)
        neighbours.select do |n|
          reachable_from(n.x, n.y, x_c, y_c) && T.must(T.must(@grid[n.y])[n.x]).shortest_dist.nil?
        end
      end

      sig { params(char: String).returns(T::Array[Gridpoint]) }
      def all_with_char(char)
        @grid.flatten.select { |gp| gp.char.eql?(char) && gp.shortest_dist }
      end

      private

      sig { returns(Integer) }
      def max_x
        T.must(@grid.first).length - 1
      end

      sig { returns(Integer) }
      def max_y
        @grid.length - 1
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Array[Coordinate]) }
      def x_neighbours(x_c, y_c)
        neighbours = []
        neighbours << Coordinate.new(x: x_c - 1, y: y_c) if x_c.positive?
        neighbours << Coordinate.new(x: x_c + 1, y: y_c) if x_c < max_x
        neighbours
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Array[Coordinate]) }
      def y_neighbours(x_c, y_c)
        neighbours = []
        neighbours << Coordinate.new(x: x_c, y: y_c - 1) if y_c.positive?
        neighbours << Coordinate.new(x: x_c, y: y_c + 1) if y_c < max_y
        neighbours
      end

      sig { params(lines: T::Array[String]).void }
      def build_grid(lines)
        lines.each_with_index do |line, y|
          @grid << []
          line.chars.each_with_index do |c, x|
            coord = Coordinate.new(x:, y:)
            if c.eql?(END_STRING)
              @grid[y]&.append(Gridpoint.new(char: c, shortest_dist: 0))
              @exploration_queue << coord
            else
              @grid[y]&.append(Gridpoint.new(char: c, shortest_dist: nil))
            end
          end
        end
      end

      sig { params(from_x: Integer, from_y: Integer, to_x: Integer, to_y: Integer).returns(T::Boolean) }
      def reachable_from(from_x, from_y, to_x, to_y)
        from_h = T.must(T.must(@grid[from_y])[from_x]).height
        to_h = T.must(T.must(@grid[to_y])[to_x]).height
        to_h <= (from_h + 1)
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 12.
    #
    # @return the answer to part a, day 12.
    def part_a
      g = Grid.new(@input_lines)
      g.explore
      g.grid.flatten.each { |gp| return T.must(gp.shortest_dist) if gp.char.eql?("S") }
      raise ArgumentError, "No end was found."
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 12.
    #
    # @return the answer to part B, day 12.
    def part_b
      g = Grid.new(@input_lines)
      g.explore
      target_gp = g.all_with_char("a").min_by { |gp| T.must(gp.shortest_dist) }
      T.must(target_gp&.shortest_dist)
    end
  end
end
