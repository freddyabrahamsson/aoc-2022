# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day17"

##
# Test class for day 17
class TestDay17 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day17.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('17'.to_i)}")
    assert_equal 3068, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day17.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('17'.to_i)}")
    assert_equal 1_514_285_714_288, d.part_b
  end
end
