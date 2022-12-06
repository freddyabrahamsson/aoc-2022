# typed: strict
# frozen_string_literal: true

require_relative "day"

module Days
  ##
  # Day 06
  class Day06 < Day
    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 06.
    #
    # @return the answer to part a, day 06.
    def part_a
      find_marker(T.must(@input_lines[0]), 4)
    end

    sig { returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 06.
    #
    # @return the answer to part B, day 06.
    def part_b
      find_marker(T.must(@input_lines[0]), 14)
    end

    sig { params(buffer: String, marker_size: Integer).returns(Integer) }
    def find_marker(buffer, marker_size)
      buffer.chars.each_cons(marker_size).with_index do |substr, idx|
        return idx + marker_size if substr.uniq.eql? substr
      end
      raise ArgumentError, "No marker found"
    end
  end
end
