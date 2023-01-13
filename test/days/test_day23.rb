# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day23"

##
# Test class for day 23
class TestDay23 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day23.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('23'.to_i)}")
    assert_equal 110, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day23.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('23'.to_i)}")
    assert_equal 20, d.part_b
  end
end
