# typed: strict
# frozen_string_literal: true

require_relative 'day'

module Days
  ##
  # Day 01
  class Day01 < Day
    sig { returns(T.any(String, Integer)) }
    def part_a
      cals_carried = 0
      max_cals = 0
      @input_lines.each do |line|
        if line.empty?
          max_cals = cals_carried if cals_carried > max_cals
          cals_carried = 0
        else
          cals_carried += line.to_i
        end
      end
      max_cals = cals_carried if cals_carried.positive? && cals_carried > max_cals
      max_cals
    end

    sig { returns(T.any(String, Integer)) }
    def part_b
      top_three = Array.new(3, 0)
      cals_carried = 0
      @input_lines.each do |line|
        if line.empty?
          maybe_insert(cals_carried, top_three)
          cals_carried = 0
        else
          cals_carried += line.to_i
        end
      end
      maybe_insert(cals_carried, top_three) if cals_carried.positive?
      top_three.reduce(:+)
    end

    sig { params(val: Integer, arr: T::Array[Integer]).void }
    def maybe_insert(val, arr)
      return unless val > T.must(arr[0])

      arr[0] = val
      arr.sort!
    end
  end
end
