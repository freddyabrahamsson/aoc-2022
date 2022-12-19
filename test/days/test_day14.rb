# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day14"

##
# Test class for day 14
class TestDay14 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day14.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('14'.to_i)}")
    assert_equal 24, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day14.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('14'.to_i)}")
    assert_equal 93, d.part_b
  end
end
