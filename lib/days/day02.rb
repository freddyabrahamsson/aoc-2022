# typed: strict
# frozen_string_literal: true

require_relative 'day'

module Days
  ##
  # Day 02
  class Day02 < Day
    RESULT_POINTS = T.let({ win: 6, draw: 3, lose: 0 }.freeze, T::Hash[T.untyped, T.untyped])
    MOVE_POINTS = T.let({ rock: 1, paper: 2, scissors: 3 }.freeze, T::Hash[Symbol, Integer])

    MOVE_CODES = T.let({ A: :rock, B: :paper, C: :scissors,
                         X: :rock, Y: :paper, Z: :scissors }.freeze, T::Hash[Symbol, Symbol])

    TARGET_OUTCOME = T.let({ X: :lose, Y: :draw, Z: :win }.freeze, T::Hash[Symbol, Symbol])
    BEATS = T.let({ rock: :paper, paper: :scissors, scissors: :rock }.freeze, T::Hash[Symbol, Symbol])
    LOSES_TO = T.let(BEATS.invert, T::Hash[Symbol, Symbol])

    sig { returns(T.any(String, Integer)) }
    def part_a
      total_score = 0
      @input_lines.each do |line|
        raise ArgumentError, "Unable to read '#{line}'" unless /(\w) (\w)/ =~ line

        opp_move = T.must(MOVE_CODES[::Regexp.last_match(1).to_s.to_sym])
        my_move = T.must(MOVE_CODES[::Regexp.last_match(2).to_s.to_sym])
        total_score += game_score(my_move, opp_move)
      end
      total_score
    end

    sig { returns(T.any(String, Integer)) }
    def part_b
      total_score = 0
      @input_lines.each do |line|
        raise ArgumentError, "Unable to read '#{line}'" unless /(\w) (\w)/ =~ line

        opp_move = T.must(MOVE_CODES[::Regexp.last_match(1).to_s.to_sym])
        target = T.must(TARGET_OUTCOME[::Regexp.last_match(2).to_s.to_sym])
        my_move = target_move(target, opp_move)
        total_score += game_score(my_move, opp_move)
      end
      total_score
    end

    sig { params(target: Symbol, opp_move: Symbol).returns(Symbol) }
    def target_move(target, opp_move)
      case target
      when :win
        T.must(BEATS[opp_move])
      when :lose
        T.must(LOSES_TO[opp_move])
      else
        opp_move
      end
    end

    sig { params(my_move: Symbol, opp_move: Symbol).returns(Integer) }
    def game_score(my_move, opp_move)
      points = T.must(MOVE_POINTS[my_move])
      points += if my_move == BEATS[opp_move]
                  RESULT_POINTS[:win]
                elsif opp_move == BEATS[my_move]
                  RESULT_POINTS[:lose]
                else
                  RESULT_POINTS[:draw]
                end
      points
    end
  end
end
