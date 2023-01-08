# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day19"

##
# Test class for day 19
class TestDay19 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day19.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('19'.to_i)}")
    assert_equal 33, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day19.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('19'.to_i)}")
    # assert_equal (56 * 62), d.part_b # UNCOMMENT ONLY IF NEEDED, SLOW TEST!
  end
end
