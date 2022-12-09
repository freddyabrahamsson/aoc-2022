# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day04"

##
# Test class for day 04
class TestDay04 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day04.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('04'.to_i)}")
    assert_equal 2, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day04.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('04'.to_i)}")
    assert_equal 4, d.part_b
  end

  sig { void }
  def test_contains_all_of
    assert (10..20).contains_all_of(10..20)
    assert (10..20).contains_all_of(10..15)
    assert (10..20).contains_all_of(15..20)
    assert (10..20).contains_all_of(15..15)
    assert (10..20).contains_all_of(10..10)
    assert (10..20).contains_all_of(20..20)
  end
end
