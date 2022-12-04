# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Require all files in the './days' folder
lib_root = File.dirname(__FILE__)
Dir.glob("#{lib_root}/days/*") { |f| require f }

###
# Collection of all the implemented days.
module Days
  extend T::Sig

  ##
  # Mapping between day numbers and the class implementing solutions for that day.
  IMPLEMENTED_DAYS = T.let({
    1 => Day01,
    2 => Day02,
    3 => Day03,
    4 => Day04
  }.freeze, T::Hash[Integer, T.class_of(Day)])
end
