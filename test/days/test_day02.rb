# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day02"

##
# Test class for day 02
class TestDay02 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day02.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('02'.to_i)}")
    assert_equal 15, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day02.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('02'.to_i)}")
    assert_equal 12, d.part_b
  end
end
