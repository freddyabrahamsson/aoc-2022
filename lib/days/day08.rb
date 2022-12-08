# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 08
  class Day08 < Day
    ##
    # A grid
    class Grid
      extend T::Sig

      sig { params(input_lines: T::Array[String]).void }
      def initialize(input_lines)
        @rows = T.let(input_lines.map { |line| line.split("").map(&:to_i) }, T::Array[T::Array[Integer]])
      end

      sig { params(x_c: Integer, y_c: Integer).returns(Integer) }
      def scenic_score(x_c, y_c)
        %i[left right up down].map { |d| los(x_c, y_c, d) }.inject(:*)
      end

      sig { params(x_c: Integer, y_c: Integer, dir: Symbol).returns(Integer) }
      def los(x_c, y_c, dir)
        this_height = height_at(x_c, y_c)
        trees_in_line = trees_in_dir(x_c, y_c, dir)
        lower = trees_in_line.take_while { |h| h < this_height }.length
        lower + (trees_in_line.length == lower ? 0 : 1) # Add the blocking tree if we have not reached the edge.
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
      def vis_from_edge(x_c, y_c)
        v_vis(x_c, y_c) || h_vis(x_c, y_c)
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
      def v_vis(x_c, y_c)
        this_height = height_at(x_c, y_c)
        trees_in_dir(x_c, y_c, :up).all? { |h| h < this_height } || trees_in_dir(x_c, y_c, :down).all? do |h|
          h < this_height
        end
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
      def h_vis(x_c, y_c)
        this_height = height_at(x_c, y_c)
        trees_in_dir(x_c, y_c, :left).all? { |h| h < this_height } || trees_in_dir(x_c, y_c, :right).all? do |h|
          h < this_height
        end
      end

      sig { params(x_c: Integer, y_c: Integer, dir: T.untyped).returns(T::Array[Integer]) }
      def trees_in_dir(x_c, y_c, dir)
        case dir
        when :left
          row_at(y_c).take(x_c - 1).reverse
        when :right
          row_at(y_c).drop(x_c)
        when :up
          col_at(x_c).take(y_c - 1).reverse
        when :down
          col_at(x_c).drop(y_c)
        else
          raise ArgumentError, "Invalid direction '#{dir}'"
        end
      end

      sig { params(y_pos: Integer).returns(T::Array[Integer]) }
      def row_at(y_pos)
        return T.must(@rows[y_pos - 1]) if y_pos.positive? && y_pos <= height

        raise ArgumentError, "Row '#{y_pos}' outside grid, must be in range [1,#{height}]"
      end

      sig { params(x_pos: Integer).returns(T::Array[Integer]) }
      def col_at(x_pos)
        return T.must(@rows.transpose[x_pos - 1]) if x_pos.positive? && x_pos <= width

        raise ArgumentError, "Column '#{x_pos}' outside grid, must be in range [1,#{width}]"
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T.untyped) }
      def height_at(x_c, y_c)
        return T.must(@rows[y_c - 1])[x_c - 1] if x_c <= width && x_c.positive? && y_c <= height && y_c.positive?

        raise ArgumentError, "Looking outside the grid: (#{x_c},#{y_c})"
      end

      sig { returns(Integer) }
      def width
        @rows.first&.length || 0
      end

      sig { returns(Integer) }
      def height
        @rows.length
      end
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 08.
    #
    # @return the answer to part a, day 08.
    def part_a
      g = Grid.new(@input_lines)
      counter = 0
      (1..g.height).each do |y_c|
        (1..g.width).each do |x_c|
          counter += 1 if g.vis_from_edge(x_c, y_c)
        end
      end
      counter
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 08.
    #
    # @return the answer to part B, day 08.
    def part_b
      g = Grid.new(@input_lines)
      max_score = 0
      (1..g.height).each do |y_c|
        (1..g.width).each do |x_c|
          this_score = g.scenic_score(x_c, y_c)
          max_score = this_score if this_score > max_score
        end
      end
      max_score
    end
  end
end
