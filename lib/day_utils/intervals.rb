# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

require_relative "integer_utils"

module DayUtils
  ##
  # Handling integer intervals
  module Intervals
    extend T::Sig

    ##
    # Defines an integer interval.
    class Interval < T::Struct
      extend T::Sig

      prop :lower, Integer
      prop :upper, Integer

      sig { params(other: Interval).returns(Integer) }
      def <=>(other)
        return (upper - other.upper).sgn if lower == other.lower

        (lower - other.lower).sgn
      end

      sig { params(num: Numeric).returns(T::Boolean) }
      def contains?(num)
        to_range.include?(num)
      end

      sig { returns(T::Enumerator[Integer]) }
      def each
        to_range.each
      end

      sig { returns(T::Range[Integer]) }
      def to_range
        (lower..upper)
      end

      sig { returns(String) }
      def to_s
        "(#{lower} -> #{upper})"
      end

      sig { returns(Integer) }
      def size
        upper - lower + 1
      end
    end

    sig { params(intervals: T::Array[T.nilable(Interval)]).returns(T::Array[Interval]) }
    ##
    # Merge a set of intervals into the smallest number of intervals required to cover the same points.
    #
    # @param intervals array of intervals to merge
    # @return an array of intervals
    def self.merge_intervals(intervals)
      sorted = intervals.reject(&:nil?).sort
      merged = sorted.first.nil? ? [] : [sorted.first.dup]

      sorted.each do |j|
        i = T.must(j)
        last_upper = merged.last.upper
        if i.lower <= last_upper + 1
          merged.last.upper = [i.upper, last_upper].max
        else
          merged << i.dup
        end
      end
      merged
    end

    sig { params(intervals: T::Array[T.nilable(Interval)]).returns(T::Array[Interval]) }
    def self.gaps(intervals)
      merged = merge_intervals(intervals)
      return [] if merged.length < 2

      holes = []
      merged.each_cons(2) do |pair|
        lower = T.must(pair[0]).upper + 1
        upper = T.must(pair[1]).lower - 1
        holes << Interval.new(lower:, upper:)
      end
      holes
    end
  end
end
