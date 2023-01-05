# typed: strict
# frozen_string_literal: true

require "set"
require_relative "day"

module Days
  ##
  # Day 17
  class Day17 < Day
    class Piece < T::Struct
      extend T::Sig

      prop :x, Integer
      prop :y, Integer
      const :t, Integer

      sig { returns(Integer) }
      def max_x
        T.must(points.max_by(&:first)).first
      end

      sig { returns(Integer) }
      def max_y
        T.must(points.max_by(&:last)).last
      end

      sig { returns(T::Set[[Integer, Integer]]) }
      def points
        case (t % 5)
        when 0 # - brick
          Set[[x, y], [x + 1, y], [x + 2, y], [x + 3, y]]
        when 1 # + brick
          Set[[x + 1, y + 2],
              [x, y + 1], [x + 1, y + 1], [x + 2, y + 1],
              [x + 1, y]]
        when 2 # _| brick
          Set[[x + 2, y + 2],
              [x + 2, y + 1],
              [x, y], [x + 1, y], [x + 2, y]]
        when 3 # | brick
          Set[[x, y], [x, y + 1], [x, y + 2], [x, y + 3]]
        when 4 # square brick
          Set[[x, y + 1], [x + 1, y + 1],
              [x, y], [x + 1, y]]
        else
          raise StandardError, "n mod 5 is more than 4"
        end
      end
    end

    ##
    # A tetris board
    class TetrisBoard < T::Struct
      extend T::Sig
      const :width, Integer, default: 7
      const :moves, T::Array[String]

      prop :occupied, T::Set[[Integer, Integer]], factory: -> { Set.[] }
      prop :moving_piece, T::Set[[Integer, Integer]], factory: -> { Set.[] }
      prop :observed_statuses, T::Hash[[Integer, Integer, T::Array[Integer]], [Integer, Integer]], factory: -> { {} }

      prop :pieces, Integer, default: 0
      prop :next_move, Integer, default: 0
      prop :max_ys, T::Array[Integer], factory: -> { [0] * 7 }

      sig { params(points: T::Set[[Integer, Integer]]).returns(T::Boolean) }
      def all_free(points)
        points.none? do |p|
          occupied.include?(p) ||
            p.first.negative? ||
            (p.first >= width) ||
            (p.last <= 0)
        end
      end

      sig { params(p: Piece, move: String).void }
      def try_move(p, move)
        case move
        when ">"
          p.x += 1 if all_free(p.with(x: p.x + 1).points)
        when "<"
          p.x -= 1 if all_free(p.with(x: p.x - 1).points)
        end
      end

      sig { void }
      def record_status
        observed_statuses[status] = [max_y, pieces]
      end

      sig { returns([Integer, Integer, T::Array[Integer]]) }
      def status
        [pieces % 5, next_move, max_ys.map { |y| y - max_y }]
      end

      sig { returns(Integer) }
      def max_y
        T.must(max_ys.max)
      end

      sig { void }
      def drop_new_piece
        p = Piece.new(x: 2, y: max_y + 4, t: pieces % 5)
        @pieces += 1

        loop do
          try_move(p, moves.fetch(next_move))
          @next_move = (next_move + 1) % moves.length

          if all_free(p.with(y: p.y - 1).points)
            p.y -= 1
          else
            ps = p.points
            occupied.merge(ps)
            ps.each { |x, y| max_ys[x] = y if y > max_ys.fetch(x) }
            break
          end
        end
      end
    end

    sig { params(n_blocks: Integer).returns(Integer) }
    def height_after_n(n_blocks)
      b = TetrisBoard.new(moves: T.must(@input_lines.first).chars)

      loop do
        b.drop_new_piece
        break if b.observed_statuses.key?(b.status)

        b.record_status
      end

      blocks_at_first_sight = b.observed_statuses.fetch(b.status).last
      delta_y = b.max_y - b.observed_statuses.fetch(b.status).first
      blocks_per_cycle = b.pieces - blocks_at_first_sight
      blocks_after_last_cycle = (n_blocks - blocks_at_first_sight) % blocks_per_cycle
      cycles = (n_blocks - blocks_at_first_sight) / blocks_per_cycle
      blocks_after_last_cycle.times { b.drop_new_piece }

      b.max_y + delta_y * (cycles - 1)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 17.
    #
    # @return the answer to part a, day 17.
    def part_a
      height_after_n(2022)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 17.
    #
    # @return the answer to part B, day 17.
    def part_b
      height_after_n(1_000_000_000_000)
    end
  end
end
