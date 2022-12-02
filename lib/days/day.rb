# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

module Days
  ##
  # Base class for solution to a single day.
  #
  # This class is only meant to be used as a base for the specific solution to a single day. The base class itself should
  # never be initialised.
  class Day
    extend T::Sig

    sig { void }
    ##
    # Initialise a new DaySolver.
    #
    # @raise [NotImplementedError] if called on the base class.
    # @return a new instance of a DaySolver.
    def initialize
      raise NotImplementedError if instance_of?(Day)

      @input_lines = T.let([], T::Array[String])
    end

    sig { params(input_file_name: String).void }
    ##
    # Read input from a file.
    #
    # @param input_file_name name of the input file.
    def read_file(input_file_name)
      File.open(input_file_name).each do |line|
        @input_lines.push(line.chomp)
      end
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Get the answer for part a.
    def part_a
      raise NotImplementedError
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Get the answer for part b.
    def part_b
      raise NotImplementedError
    end
  end
end
