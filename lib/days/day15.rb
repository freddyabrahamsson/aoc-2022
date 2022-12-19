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
      target_y = 10 # Change to 2_000_000 if running to solve actual problem
      covered = []
      beacons = Set.new
      @input_lines.each do |line|
        s_coord = sensor_coord(line)
        b_coord = beacon_coord(line)
        d = manhattan_distance(s_coord, b_coord)
        covered << interval_within_man_dist(d, target_y, s_coord)
        beacons.add(b_coord.x) if b_coord.y == target_y
      end
      merged = DayUtils::Intervals.merge_intervals(covered)
      total_int_size = merged.map(&:size).sum
      beacons.each do |beacon|
        total_int_size -= 1 if merged.any? { |i| i.contains?(beacon) }
      end
      total_int_size
    end

    sig { override.returns(T.any(String, Integer)) }
    ##
    # Solution to part b of day 15.
    #
    # @return the answer to part B, day 15.
    def part_b
      bound = 20 # Change to 4_000_000 if solving actual puzzle
      s_coords = []
      ds = []
      @input_lines.each do |line|
        s_coord = sensor_coord(line)
        d = manhattan_distance(s_coord, beacon_coord(line))
        s_coords << s_coord
        ds << d
      end
      (0..bound).each do |y|
        covered = s_coords.map.with_index do |s_coord, n|
          interval_within_man_dist(ds[n], y, s_coord)
        end
        gaps = DayUtils::Intervals.gaps(covered)
        next unless gaps.length == 1

        gap = T.must(gaps.first)
        return gap.lower * 4_000_000 + y if (gap.lower == gap.upper) && gap.lower < bound
      end

      raise ArgumentError, "No gap found"
    end
  end
end
