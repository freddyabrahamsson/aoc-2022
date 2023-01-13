# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 22
  class Day22 < Day
    class Square < T::Enum
      extend T::Sig

      enums do
        Free = new
        Wall = new
      end

      sig { params(str: String).returns(Square) }
      def self.from_str(str)
        case str
        when "#" then Wall
        when "." then Free
        else
          raise ArgumentError, "Unknown square type '#{str}"
        end
      end
    end

    class Direction < T::Enum
      extend T::Sig
      enums do
        Right = new
        Down = new
        Left = new
        Up = new
      end

      sig { returns(Integer) }
      def dir_num
        case self
        when Right then 0
        when Down then 1
        when Left then 2
        when Up then 3
        end
      end

      sig { returns(Direction) }
      def turn_right
        case self
        when Right then Down
        when Down then Left
        when Left then Up
        when Up then Right
        end
      end

      sig { returns(Direction) }
      def turn_left
        case self
        when Right then Up
        when Down then Right
        when Left then Down
        when Up then Left
        end
      end
    end

    class Walker < T::Struct
      extend T::Sig
      prop :x_coord, Integer
      prop :y_coord, Integer
      prop :dir, Direction

      sig { params(str: String).void }
      def turn(str)
        case str
        when "R" then self.dir = dir.turn_right
        when "L" then self.dir = dir.turn_left
        end
      end
    end

    class Row < T::Struct
      extend T::Sig
      prop :start_idx, Integer
      prop :squares, T::Array[Square]

      sig { returns(Integer) }
      def last_idx
        start_idx + squares.length - 1
      end

      sig { params(col: Integer).returns(T.nilable(Square)) }
      def content(col)
        idx = col - start_idx
        idx.negative? ? nil : squares[idx]
      end
    end

    class Board < T::Struct
      extend T::Sig

      prop :walker, Walker
      prop :rows, T::Array[Row]

      sig { params(moves: T::Array[String]).void }
      def execute_moves(moves)
        moves.each do |move|
          if move.to_i.to_s == move
            move.to_i.times { move_walker }
          else
            walker.turn(move)
          end
        end
      end

      private

      sig { void }
      def move_walker
        next_x, next_y = case walker.dir
                         when Direction::Right then right_of(walker.x_coord, walker.y_coord)
                         when Direction::Down then below(walker.x_coord, walker.y_coord)
                         when Direction::Left then left_of(walker.x_coord, walker.y_coord)
                         when Direction::Up then above(walker.x_coord, walker.y_coord)
                         end
        return unless rows.fetch(next_y).content(next_x) == Square::Free

        walker.x_coord = next_x
        walker.y_coord = next_y
      end

      sig { params(x: Integer, y: Integer).returns([Integer, Integer]) }
      def right_of(x, y)
        row = rows.fetch(y)
        row.content(x + 1).nil? ? [row.start_idx, y] : [x + 1, y]
      end

      sig { params(x: Integer, y: Integer).returns([Integer, Integer]) }
      def left_of(x, y)
        row = rows.fetch(y)
        row.content(x - 1).nil? ? [row.last_idx, y] : [x - 1, y]
      end

      sig { params(x: Integer, y: Integer).returns([Integer, Integer]) }
      def above(x, y)
        return [x, y - 1] unless (y - 1).negative? || rows.fetch(y - 1).content(x).nil?

        [x, T.must(rows.rindex { |r| !r.content(x).nil? })]
      end

      sig { params(x: Integer, y: Integer).returns([Integer, Integer]) }
      def below(x, y)
        return [x, y + 1] unless (y + 1 >= rows.length) || rows.fetch(y + 1).content(x).nil?

        [x, T.must(rows.index { |r| !r.content(x).nil? })]
      end
    end

    sig { params(line: String).returns(Row) }
    def parse_row(line)
      start_idx = T.must(/\S/ =~ line)
      squares = line.strip.chars.map { |c| Square.from_str(c) }
      Row.new(start_idx:, squares:)
    end

    sig { params(line: String).returns(T::Array[String]) }
    def parse_moves(line)
      moves = T.let(line.partition(/[A-Z]/), T::Array[String])
      moves += T.must(moves.pop&.partition(/[A-Z]/)) until moves.last&.empty?
      moves.reject(&:empty?)
    end

    sig { params(lines: T::Array[String]).returns([Board, T::Array[String]]) }
    def parse_input(lines)
      rows = T.let([], T::Array[Row])
      moves = T.let([], T::Array[String])
      lines.each do |line|
        rows << parse_row(line) if line =~ /(\.|\#)/
        moves = parse_moves(line) if line =~ /^(\d|\w)+$/
      end
      b = Board.new(rows:, walker: Walker.new(x_coord: rows.fetch(0).start_idx, y_coord: 0, dir: Direction::Right))
      [b, moves]
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 22.
    #
    # @return the answer to part a, day 22.
    def part_a
      b, moves = parse_input(@input_lines)
      b.execute_moves(moves)
      final_x = b.walker.x_coord + 1
      final_y = b.walker.y_coord + 1
      1000 * final_y + 4 * final_x + b.walker.dir.dir_num
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 22.
    #
    # @return the answer to part B, day 22.
    def part_b
      super
    end
  end
end
