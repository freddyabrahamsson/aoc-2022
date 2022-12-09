# typed: strict
# frozen_string_literal: true

require_relative "day"

# rubocop:disable Style/Documentation
class Range
  extend T::Sig

  sig { params(other_range: T::Range[T.untyped]).returns(T::Boolean) }
  ##
  # Check if another range is completely contained within this range.
  #
  # @param other_range other range
  # @return true if both endpoints of the other range are included in this range.
  def contains_all_of(other_range)
    include?(other_range.begin) && include?(other_range.end)
  end

  sig { params(other_range: T::Range[T.untyped]).returns(T::Boolean) }
  ##
  # Check if another range overlaps with this range.
  #
  # Overlaps include one of the ranges fully containing the other range.
  #
  # @param other_range range to check against
  # @return true if the other range overlaps with this one.
  def overlaps_with(other_range)
    include?(other_range.begin) || include?(other_range.end) || other_range.contains_all_of(self)
  end
end
# rubocop:enable Style/Documentation

module Days
  ##
  # Day 04
  class Day04 < Day
    PAIR_PATTERN = /(\d+)-(\d+),(\d+)-(\d+)/ # Regex pattern to capture pairs from day 4 input.

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 04.
    #
    # @return the answer to part a, day 04.
    def part_a
      count = 0
      @input_lines.each do |line|
        raise ArgumentError, "Unable to read '#{line}'" unless PAIR_PATTERN =~ line

        range_one = ((Regexp.last_match(1).to_i)..(Regexp.last_match(2).to_i))
        range_two = ((Regexp.last_match(3).to_i)..(Regexp.last_match(4).to_i))

        count += 1 if range_one.contains_all_of(range_two) || range_two.contains_all_of(range_one)
      end
      count
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 04.
    #
    # @return the answer to part B, day 04.
    def part_b
      count = 0
      @input_lines.each do |line|
        raise ArgumentError, "Unable to read '#{line}'" unless PAIR_PATTERN =~ line

        range_one = ((Regexp.last_match(1).to_i)..(Regexp.last_match(2).to_i))
        range_two = ((Regexp.last_match(3).to_i)..(Regexp.last_match(4).to_i))

        count += 1 if range_one.overlaps_with(range_two)
      end
      count
    end
  end
end
