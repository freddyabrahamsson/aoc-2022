# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 05
  class Day05 < Day
    LAYER_PATTERN = /\[\w+\]/ # Pattern for a line with a layer of crates.
    BASE_PATTERN = /\d+$/x # Pattern for the stack labels.
    MOVE_PATTERN = /move (\d+) from (\d+) to (\d+)/ # Pattern for a line describing a move.

    ##
    # Collect the properties of a move.
    class Move < T::Struct
      const :crates, Integer
      const :from, Integer
      const :to, Integer
    end

    ##
    # Describes a crane setup, consisting of a list of stacks and a list of moves.
    class CraneSetup < T::Struct
      const :layout, T::Array[T::Array[String]]
      const :moves, T::Array[Move]
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 05.
    #
    # @return the answer to part a, day 05.
    def part_a
      setup = parse_setup(@input_lines)
      run_crane9000(setup.layout, setup.moves)

      setup.layout.map(&:last).join
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 05.
    #
    # @return the answer to part B, day 05.
    def part_b
      setup = parse_setup(@input_lines)
      run_crane9001(setup.layout, setup.moves)

      setup.layout.map(&:last).join
    end

    sig { params(input_lines: T::Array[String]).returns(CraneSetup) }
    ##
    # Read the setup of crates and moves from a set if input lines
    #
    # @param input_lines array of strings describing the setup
    # @return a structured CraneSetup
    def parse_setup(input_lines)
      moves = []
      layout = []
      n_stacks = 0
      input_lines.each do |line|
        layout << line if LAYER_PATTERN =~ line
        moves << parse_move(line) if MOVE_PATTERN =~ line
        n_stacks = line.split("").length if BASE_PATTERN =~ line
      end
      layout = parse_stacks(layout.reverse, n_stacks)

      CraneSetup.new(layout:, moves:)
    end

    sig { params(stack_strs: T::Array[String], n_stacks: Integer).returns(T::Array[T::Array[String]]) }
    ##
    # Parse a set of stacks of crates from a string representation
    #
    # @param stack_strs string representation of the stacks
    # @param n_stacks number of stacks
    # @return an array containing the stacks of crates
    def parse_stacks(stack_strs, n_stacks)
      stacks = Array.new(n_stacks) { [] }
      stack_strs.each do |level|
        stack_n = 0
        until stack_pos(stack_n) >= level.length || stack_n >= n_stacks
          char_here = T.must(level[stack_pos(stack_n)])
          stacks[stack_n] << char_here unless char_here.strip.empty?
          stack_n += 1
        end
      end

      stacks
    end

    sig { params(stack_n: Integer).returns(Integer) }
    ##
    # Get the position of the content of a crate in stack n in a string
    #
    # @param stack_n stack number
    # @return the content of the crate in that stack.
    def stack_pos(stack_n)
      4 * stack_n + 1
    end

    sig { params(line: T.nilable(String)).returns(Move) }
    ##
    # Read the parameters for a move from a string to a hash.
    #
    # @param line string representation of the move
    # @return a hash containing the
    def parse_move(line)
      raise ArgumentError, "cannot read move from '#{line}}'" unless MOVE_PATTERN =~ line

      Move.new(crates: Regexp.last_match(1).to_i,
               from: Regexp.last_match(2).to_i - 1,
               to: Regexp.last_match(3).to_i - 1)
    end

    sig { params(stacks: T::Array[T::Array[String]], moves: T::Array[Move]).void }
    ##
    # Run the given moves on the given set of stacks with the CrateMover 9000. Modifies the set of stacks in place.
    #
    # @param stacks set of stacks
    # @param moves list of moves
    def run_crane9000(stacks, moves)
      moves.each do |move|
        move.crates.times { T.must(stacks[move.to]) << T.must(T.must(stacks[move.from]).pop) }
      end
    end

    sig { params(stacks: T::Array[T::Array[String]], moves: T::Array[Move]).void }
    ##
    # Run the given moves on the given set of stacks with the CrateMover 9001. Modifies the set of stacks in place.
    #
    # @param stacks set of stacks
    # @param moves list of moves
    def run_crane9001(stacks, moves)
      moves.each do |move|
        T.must(stacks[move.to]).concat T.must(stacks[move.from]).pop(move.crates)
      end
    end
  end
end
