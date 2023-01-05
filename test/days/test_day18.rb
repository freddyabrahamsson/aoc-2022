# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day18"

##
# Test class for day 18
class TestDay18 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day18.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('18'.to_i)}")
    assert_equal 64, d.part_a
  end

  sig { void }
  def test_part_a1
    d = Days::Day18.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(18, 1)}")
    assert_equal 10, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day18.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('18'.to_i)}")
    assert_equal 58, d.part_b
  end
end
