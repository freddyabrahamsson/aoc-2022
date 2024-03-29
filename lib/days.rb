# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# Require all files in the './days' folder
lib_root = File.dirname(__FILE__)
Dir.glob("#{lib_root}/days/*") { |f| require f }

###
# Collection of all the implemented days.
module Days
  extend T::Sig

  ##
  # Custom error if day is not implemented.
  class DayNotImplementedError < StandardError
    extend T::Sig

    sig { params(msg: T.nilable(T.any(String, Symbol, Exception))).void }
    def initialize(msg = "Day not implemented.")
      super
    end
  end

  ##
  # Mapping between day numbers and the class implementing solutions for that day.
  IMPLEMENTED_DAYS = T.let({
    1 => Day01,
    2 => Day02,
    3 => Day03,
    4 => Day04,
    5 => Day05,
    6 => Day06,
    7 => Day07,
    8 => Day08,
    9 => Day09,
    10 => Day10,
    11 => Day11,
    12 => Day12,
    13 => Day13,
    14 => Day14,
    15 => Day15,
    16 => Day16,
    17 => Day17,
    18 => Day18,
    19 => Day19,
    20 => Day20,
    21 => Day21,
    22 => Day22,
    23 => Day23
  }.freeze, T::Hash[Integer, T.class_of(Day)])
end
