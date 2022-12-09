# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day05"

##
# Test class for day 05
class TestDay05 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day05.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('05'.to_i)}")
    assert_equal "CMZ", d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day05.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('05'.to_i)}")
    assert_equal "MCD", d.part_b
  end
end
