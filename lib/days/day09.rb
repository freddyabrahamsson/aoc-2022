# typed: strict
# frozen_string_literal: true

require "set"

require_relative "day"

module Days
  ##
  # Day 09
  class Day09 < Day
    ##
    # A knot on the rope
    class Knot < T::Struct
      extend T::Sig

      prop :x, Integer
      prop :y, Integer
      prop :next, T.nilable(Knot)
      const :previous, T.nilable(Knot)

      sig { params(other: Knot).returns(T::Boolean) }
      ##
      # Check if another knot is adjacent to this one.
      #
      # @param other knot to measure against
      # @return true if the other knot is adjacent to this one
      def adjacent(other)
        x_dist = other.x - x
        y_dist = other.y - y
        x_dist.abs <= 1 && y_dist.abs <= 1
      end

      sig { params(other: Knot).void }
      ##
      # Move this knot one step towards another knot.
      #
      # @param other knot to move towards
      def move_towards(other)
        x_dist = other.x - x
        y_dist = other.y - y
        self.x += x_dist / x_dist.abs unless x_dist.zero?
        self.y += y_dist / y_dist.abs unless y_dist.zero?
      end
    end

    ##
    # A rope, represented as a linked-list.
    class Rope
      extend T::Sig

      sig { params(tail_size: Integer).void }
      def initialize(tail_size)
        @head = T.let(Knot.new(x: 0, y: 0, previous: nil, next: nil), Knot)
        @last = T.let(@head, Knot)
        @visited = T.let(Set.new, T::Set[T::Hash[Symbol, Integer]])
        tail_size.times { add_knot(0, 0) }
        @visited.add({ x: @last.x, y: @last.y })
      end

      sig { params(movement_line: String).void }
      ##
      # Move the rope according to a single instruction.
      #
      # @param movement_line string with instruction
      def move(movement_line)
        tokens = movement_line.split(" ")
        dir = T.must(tokens[0]).to_sym
        steps = tokens[1].to_i
        steps.times { move_head(dir) }
      end

      sig { returns(Integer) }
      ##
      # Get the number of nodes visited by the tail end of the rope.
      #
      # @return number of nodes visited by the tail
      def n_visited
        @visited.size
      end

      private

      MOVES = T.let({ R: proc { |n| n.x += 1 },
                      L: proc { |n| n.x -= 1 },
                      U: proc { |n| n.y += 1 },
                      D: proc { |n| n.y -= 1 } }.freeze,
                    T::Hash[Symbol, Proc]) # Mappings from directions to moving actions.

      sig { params(x_pos: Integer, y_pos: Integer).void }
      def add_knot(x_pos, y_pos)
        new_knot = Knot.new(x: x_pos, y: y_pos, previous: @last, next: nil)
        @last.next = new_knot
        @last = new_knot
      end

      sig { params(dir: Symbol).void }
      ##
      # Move the first knot on the rope one step in the given direction.
      #
      # @param dir direction to move in
      def move_head(dir)
        MOVES[dir]&.call(@head) || (raise ArgumentError, "Invalid direction '#{dir}'")
        move_knot(T.must(@head.next))
      end

      sig { params(knot: Knot).void }
      ##
      # Move a knot towards the knot in front of it, unless they are already adjacent.
      #
      # @param knot knot to move
      def move_knot(knot)
        knot.move_towards(T.must(knot.previous)) unless knot.adjacent(T.must(knot.previous))

        if knot.next
          move_knot(T.must(knot.next))
        else # At the last node, record position
          @visited.add({ x: @last.x, y: @last.y })
        end
      end
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 09.
    #
    # @return the answer to part a, day 09.
    def part_a
      r = Rope.new(1)
      @input_lines.each { |line| r.move line }
      r.n_visited
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 09.
    #
    # @return the answer to part B, day 09.
    def part_b
      r = Rope.new(9)
      @input_lines.each { |line| r.move line }
      r.n_visited
    end
  end
end
