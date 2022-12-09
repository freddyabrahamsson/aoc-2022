# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day01"

##
# Test class for day 01
class TestDay01 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day01.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('01'.to_i)}")
    assert_equal 24_000, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day01.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('01'.to_i)}")
    assert_equal 45_000, d.part_b
  end

  sig { void }
  def test_maybe_insert
    d = Days::Day01.new
    a = [1, 2, 3]
    d.maybe_insert(0, a)
    assert_includes a, 1, "0 was inserted even though 1 was the smallest"
    assert_includes a, 2, "0 was inserted even though 1 was the smallest"
    assert_includes a, 3, "0 was inserted even though 1 was the smallest"
    a = [10, 12, 44]
    d.maybe_insert(32, a)
    assert_includes a, 32, "32 was not inserted even though 10 was the smallest"
    assert_includes a, 12, "12 was shifted out even though 10 was the smallest"
    assert_includes a, 44, "44 was shifted out even though 10 was the smallest"
  end
end
