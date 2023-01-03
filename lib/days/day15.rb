# typed: strict
# frozen_string_literal: true

require "set"

require_relative "day"
require_relative "../day_utils/intervals"

module Days
  ##
  # Day 15
  class Day15 < Day
    class Coordinate < T::Struct
      prop :x, Integer
      prop :y, Integer
    end

    SENSOR_LINE = /Sensor at x=(\S+), y=(\S+): closest beacon is at x=(\S+), y=(\S+)/
    PART_A_TARGET = 10 # Change to 2_000_000 if running to solve actual problem
    PART_B_BOUND = 20 # Change to 4_000_000 if solving actual puzzle

    sig { params(line: T.nilable(String)).returns(Days::Day15::Coordinate) }
    def sensor_coord(line)
      return Coordinate.new(x: Regexp.last_match(1).to_i, y: Regexp.last_match(2).to_i) if SENSOR_LINE =~ line

      raise ArgumentError, "Unable to parse sensor positon from '#{line}'"
    end

    sig { params(line: T.nilable(String)).returns(Days::Day15::Coordinate) }
    def beacon_coord(line)
      return Coordinate.new(x: Regexp.last_match(3).to_i, y: Regexp.last_match(4).to_i) if SENSOR_LINE =~ line

      raise ArgumentError, "Unable to parse sensor positon from '#{line}'"
    end

    sig { params(coord_a: Coordinate, coord_b: Coordinate).returns(Integer) }
    def manhattan_distance(coord_a, coord_b)
      (coord_a.x - coord_b.x).abs + (coord_a.y - coord_b.y).abs
    end

    sig do
      params(man_dist: Integer, y_coord: Integer, coord: Coordinate)
        .returns(T.nilable(DayUtils::Intervals::Interval))
    end
    def interval_within_man_dist(man_dist, y_coord, coord)
      max_x_dist = man_dist - (y_coord - coord.y).abs
      return nil if max_x_dist.negative?

      lower = coord.x - max_x_dist
      upper = coord.x + max_x_dist
      DayUtils::Intervals::Interval.new(lower:, upper:)
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part a of day 15.
    #
    # @return the answer to part a, day 15.
    def part_a
      covered = []
      beacons = Set.new
      @input_lines.each do |line|
        s_coord = sensor_coord(line)
        b_coord = beacon_coord(line)
        covered << interval_within_man_dist(manhattan_distance(s_coord, b_coord), PART_A_TARGET, s_coord)
        beacons.add(b_coord.x) if b_coord.y == PART_A_TARGET
      end
      merged = DayUtils::Intervals.merge_intervals(covered)
      total_int_size = merged.map(&:size).sum
      beacons.each { |b| total_int_size -= 1 if merged.any? { |i| i.contains?(b) } }
      total_int_size
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 15.
    #
    # @return the answer to part B, day 15.
    def part_b
      s_coords = []
      ds = []
      @input_lines.each do |line|
        s_coord = sensor_coord(line)
        s_coords << s_coord
        ds << manhattan_distance(s_coord, beacon_coord(line))
      end
      (0..PART_B_BOUND).each do |y|
        covered = s_coords.zip(ds).map { |s_c, d| interval_within_man_dist(d, y, s_c) }
        gaps = DayUtils::Intervals.gaps(covered)
        next unless gaps.length == 1

        gap = T.must(gaps.first)
        return gap.lower * 4_000_000 + y if (gap.lower == gap.upper) && gap.lower < PART_B_BOUND
      end

      raise ArgumentError, "No gap found"
    end
  end
end
