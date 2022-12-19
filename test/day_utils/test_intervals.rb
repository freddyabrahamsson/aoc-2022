# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/day_utils/intervals"

##
# Test class for day 02
class TestIntervals < Minitest::Test
  extend T::Sig

  include DayUtils::Intervals

  sig { void }
  def test_create_intervals
    i = Interval.new(lower: 0, upper: 1)
    assert_instance_of Interval, i, "Failed to create interval (0-1)"
  end

  sig { void }
  def test_contains
    i = Interval.new(lower: 1, upper: 10)
    assert i.contains?(5), "(1-10) did not include 5"
    refute i.contains?(11), "(1-10) contained 11"
  end

  sig { void }
  def test_each
    i = Interval.new(lower: 1, upper: 10)
    assert_instance_of Enumerator, i.each, "i.each is not an Enumerator"
    assert_equal 10, i.each.size, "(1-10).each does not have size 10"
  end

  sig { void }
  def test_to_range
    i = Interval.new(lower: 1, upper: 10)
    assert_instance_of Range, i.to_range, "i.to_range is not a range"
    assert_equal 10, i.to_range.size, "(1-10).to_range does not have size 10"
  end

  sig { void }
  def test_size
    i = Interval.new(lower: 1, upper: 10)
    assert_equal 10, i.size, "(1-10) does not have size 10"
  end
end

class TestIntervalMerge < Minitest::Test
  extend T::Sig

  include DayUtils::Intervals

  sig { void }
  def test_merge_overlapping_ordered
    i = Interval.new(lower: 1, upper: 10)
    j = Interval.new(lower: 8, upper: 15)
    merged_intervals = DayUtils::Intervals.merge_intervals([j, i])
    interval = merged_intervals.first

    assert_equal 1, merged_intervals.length, "Merging (1-10) with (8-15) did not give one interval."
    assert_equal 1, interval&.lower, "Merging (1-10) with (8-15) does not give 1 as lower"
    assert_equal 15, interval&.upper, "Merging (1-10) with (8-15) does not give 15 as upper"
  end

  sig { void }
  def test_merge_overlapping_unordered
    i = Interval.new(lower: 1, upper: 10)
    j = Interval.new(lower: 8, upper: 15)
    merged_intervals = DayUtils::Intervals.merge_intervals([j, i])
    interval = merged_intervals.first

    assert_equal 1, merged_intervals.length, "Merging (1-10) with (8-15) did not give one interval."
    assert_equal 1, interval&.lower, "Merging (8-15) with (1-10) does not give 1 as lower"
    assert_equal 15, interval&.upper, "Merging (8-15) with (1-10) does not give 15 as upper"
  end

  sig { void }
  def test_merge_three_ordered
    i = Interval.new(lower: 1, upper: 10)
    j = Interval.new(lower: 8, upper: 15)
    k = Interval.new(lower: 13, upper: 17)

    merged_intervals = DayUtils::Intervals.merge_intervals([i, j, k])
    interval = merged_intervals.first

    assert_equal 1, merged_intervals.length, "Merging (1-10) with (8-15) did not give one interval."
    assert_equal 1, interval&.lower, "Merging (1-10), (8-15), (13-17) does not give 1 as lower"
    assert_equal 17, interval&.upper, "Merging (1-10),(8-15), (13-17) does not give 17 as upper"
  end

  sig { void }
  def test_merge_two_separate
    i = Interval.new(lower: 1, upper: 10)
    j = Interval.new(lower: 15, upper: 20)
    merged_intervals = DayUtils::Intervals.merge_intervals([j, i])
    interval_a = merged_intervals.first
    interval_b = merged_intervals.last

    assert_equal 2, merged_intervals.length, "Merging (1-10) with (15-20) did not give a two intervals"
    assert_equal 1, interval_a&.lower, "Merging (1-10) with (15-20) did not give 1 as lower in interval a"
    assert_equal 10, interval_a&.upper, "Merging (1-10) with (15-20) did not give 10 as upper in interval a"
    assert_equal 15, interval_b&.lower, "Merging (1-10) with (15-20) did not give 15 as lower in interval b"
    assert_equal 20, interval_b&.upper, "Merging (1-10) with (15-20) did not give 20 as upper in interval b"
  end

  sig { void }
  def test_merge_two_touching
    i = Interval.new(lower: 1, upper: 10)
    j = Interval.new(lower: 11, upper: 15)
    merged_intervals = DayUtils::Intervals.merge_intervals([j, i])
    interval = merged_intervals.first

    assert_equal 1, merged_intervals.length, "Merging (1-10) with (8-15) did not give one interval."
    assert_equal 1, interval&.lower, "Merging (8-15) with (1-10) does not give 1 as lower"
    assert_equal 15, interval&.upper, "Merging (8-15) with (1-10) does not give 15 as upper"
  end
end
