# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/day_utils/string_utils"

##
# Test class for day 02
class TestIntervals < Minitest::Test
  extend T::Sig

  sig { void }
  def test_grab_numbers_examples
    assert_equal [1.0], "1".grab_numbers
    assert_equal [1.0], "1 is a number".grab_numbers
    assert_equal [-2.1], "-2.1 is a float".grab_numbers
    assert_equal [22.0], "part1 is a name, 22 is a number".grab_numbers
    assert_equal [1.0, 2.0, 3.0], "1 and 2 and 3".grab_numbers
  end
end
