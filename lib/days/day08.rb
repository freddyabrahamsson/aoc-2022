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
      ##
      # Scenic score of a location. Defined as the product of the line of sight length in all four direction.
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @return the scenic score
      def scenic_score(x_c, y_c)
        %i[left right up down].map { |d| los(x_c, y_c, d) }.inject(:*)
      end

      sig { params(x_c: Integer, y_c: Integer, dir: Symbol).returns(Integer) }
      ##
      # Line of sight length along a given direction. The length is defined as the number of trees that are visible from
      # the location, including the first one blocking the view.
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @param dir direction to look in
      # @return the length of the line of sight
      def los(x_c, y_c, dir)
        this_height = height_at(x_c, y_c)
        trees_in_line = trees_in_dir(x_c, y_c, dir)
        lower = trees_in_line.take_while { |h| h < this_height }.length
        lower + (trees_in_line.length == lower ? 0 : 1) # Add the blocking tree if we have not reached the edge.
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
      ##
      # Checks if a tree is visible from the edge in any direction.
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @return true if the tree is visible from any edge
      def vis_from_edge(x_c, y_c)
        v_vis(x_c, y_c) || h_vis(x_c, y_c)
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
      ##
      # Checks if a tree is visible in any vertical direction (up and down).
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @return true if the tree is visible.
      def v_vis(x_c, y_c)
        this_height = height_at(x_c, y_c)
        trees_in_dir(x_c, y_c, :up).all? { |h| h < this_height } || trees_in_dir(x_c, y_c, :down).all? do |h|
          h < this_height
        end
      end

      sig { params(x_c: Integer, y_c: Integer).returns(T::Boolean) }
      ##
      # Checks if a tree is visible in any horizontal direction (left and right).
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @return true if the tree is visible.
      def h_vis(x_c, y_c)
        this_height = height_at(x_c, y_c)
        trees_in_dir(x_c, y_c, :left).all? { |h| h < this_height } || trees_in_dir(x_c, y_c, :right).all? do |h|
          h < this_height
        end
      end

      sig { params(x_c: Integer, y_c: Integer, dir: T.untyped).returns(T::Array[Integer]) }
      ##
      # Get a list of all the trees in a given direction from a location. Trees are listed with the closest one first.
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @param dir direction to look in
      # @return a list of all the trees.
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

      sig { params(x_c: Integer, y_c: Integer).returns(T.untyped) }
      ##
      # Get the height of the tree at a given location.
      #
      # @param x_c x-coordinate
      # @param y_c y-coordinate
      # @return heigh of the tree
      def height_at(x_c, y_c)
        return T.must(@rows[y_c - 1])[x_c - 1] if x_c <= width && x_c.positive? && y_c <= height && y_c.positive?

        raise ArgumentError, "Looking outside the grid: (#{x_c},#{y_c})"
      end

      sig { returns(Integer) }
      ##
      # Width (number of columns) of the grid.
      #
      # @return the width
      def width
        @rows.first&.length || 0
      end

      sig { returns(Integer) }
      ##
      # Height (number of rows) of the grid.
      #
      # @return the height
      def height
        @rows.length
      end

      private

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
