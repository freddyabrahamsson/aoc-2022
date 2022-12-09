# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day06"

##
# Test class for day 07
class TestDay06 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('06'.to_i)}")
    assert_equal 7, d.part_a
  end

  sig { void }
  def test_part_a1
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 1)}")
    assert_equal 5, d.part_a
  end

  sig { void }
  def test_part_a2
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 2)}")
    assert_equal 6, d.part_a
  end

  sig { void }
  def test_part_a3
    d = Days::Day06.new

    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 3)}")
    assert_equal 10, d.part_a
  end

  sig { void }
  def test_part_a4
    d = Days::Day06.new

    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 4)}")
    assert_equal 11, d.part_a
  end

  sig { void }
  def test_part_b
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('06'.to_i)}")
    assert_equal 19, d.part_b
  end

  sig { void }
  def test_part_b1
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 1)}")
    assert_equal 23, d.part_b
  end

  sig { void }
  def test_part_b2
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 2)}")
    assert_equal d.part_b, 23
  end

  sig { void }
  def test_part_b3
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 3)}")
    assert_equal d.part_b, 29
  end

  sig { void }
  def test_part_b4
    d = Days::Day06.new
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 4)}")
    assert_equal d.part_b, 26
  end

  sig { void }
  def test_find_marker_invalid
    d = Days::Day06.new
    buffer = "ababababababababababab"
    assert_raises(ArgumentError) { d.find_marker(buffer, 3) }
  end
end
