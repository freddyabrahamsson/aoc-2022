# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 02
  class Day02 < Day
    # Number of points from each outcome.
    RESULT_POINTS = T.let({ win: 6, draw: 3, lose: 0 }.freeze, T::Hash[T.untyped, T.untyped])
    # Number of points awarded to each move.
    MOVE_POINTS = T.let({ rock: 1, paper: 2, scissors: 3 }.freeze, T::Hash[Symbol, Integer])

    # Mapping "encrypted" moves to the actual move.
    MOVE_CODES = T.let({ A: :rock, B: :paper, C: :scissors,
                         X: :rock, Y: :paper, Z: :scissors }.freeze, T::Hash[Symbol, Symbol])
    # Mapping "encrypted" target outcomes to actual outcomes
    TARGET_OUTCOME = T.let({ X: :lose, Y: :draw, Z: :win }.freeze, T::Hash[Symbol, Symbol])

    # Rules of the game, declared as :rock == BEATS[:scissors]
    BEATS = T.let({ rock: :paper, paper: :scissors, scissors: :rock }.freeze, T::Hash[Symbol, Symbol])
    # Inverse mapping of the rules, declared as :rock == LOSES_TO[:paper]
    LOSES_TO = T.let(BEATS.invert, T::Hash[Symbol, Symbol])

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 02.
    #
    # @return the answer to part a, day 02.
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

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 02.
    #
    # @return the answer to part b, day 02.
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
    ##
    # Get the move resulting in the desired outcome, given your opponent's move.
    #
    # @param target desired outcome
    # @param opp_move opponent's move
    # @return the move that will give you the desired outcome.
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
    ##
    # Compute the number of points from a single game.
    #
    # @param my_move the move used by the player
    # @param opp_move the move used by the opponent
    # @return the number of points won by the player.
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
