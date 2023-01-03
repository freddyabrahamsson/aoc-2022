# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day16"

##
# Test class for day 16
class TestDay16 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day16.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('16'.to_i)}")
    assert_equal 1651, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day16.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('16'.to_i)}")
    assert_equal 1707, d.part_b
  end
end
