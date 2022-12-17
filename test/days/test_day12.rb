# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day12"

##
# Test class for day 12
class TestDay12 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day12.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('12'.to_i)}")
    assert_equal 31, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day12.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('12'.to_i)}")
    assert_equal 29, d.part_b
  end
end
