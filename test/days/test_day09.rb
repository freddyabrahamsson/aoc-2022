# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day09"

##
# Test class for day 09
class TestDay09 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day09.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('09'.to_i)}")
    assert_equal 13, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day09.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('09'.to_i)}")
    assert_equal 1, d.part_b
  end

  sig { void }
  def test_part_b2
    d = Days::Day09.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(9, 1)}")
    assert_equal 36, d.part_b
  end
end
