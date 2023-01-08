# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day21"

##
# Test class for day 21
class TestDay21 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day21.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('21'.to_i)}")
    assert_equal 152, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day21.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('21'.to_i)}")
    assert_equal 301, d.part_b
  end
end
