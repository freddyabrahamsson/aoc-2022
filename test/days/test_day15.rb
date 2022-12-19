# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day15"

##
# Test class for day 15
class TestDay15 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day15.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('15'.to_i)}")
    assert_equal 26, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day15.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('15'.to_i)}")
    assert_equal 56_000_011, d.part_b
  end
end
