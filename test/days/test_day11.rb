# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day11"

##
# Test class for day 11
class TestDay11 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day11.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('11'.to_i)}")
    assert_equal 10_605, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day11.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('11'.to_i)}")
    assert_equal 2_713_310_158, d.part_b
  end
end
