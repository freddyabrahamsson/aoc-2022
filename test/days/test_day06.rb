# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day06"

class TestDay06 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('06'.to_i)}")
    assert_equal d.part_a, 7
  end

  sig { void }
  def test_part_a1
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 1)}")
    assert_equal d.part_a, 5
  end

  sig { void }
  def test_part_a2
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 2)}")
    assert_equal d.part_a, 6
  end

  sig { void }
  def test_part_a3
    d = T.let(Days::Day06.new, Days::Day06)

    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 3)}")
    assert_equal d.part_a, 10
  end

  sig { void }
  def test_part_a4
    d = T.let(Days::Day06.new, Days::Day06)

    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 4)}")
    assert_equal d.part_a, 11
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('06'.to_i)}")
    assert_equal d.part_b, 19
  end

  sig { void }
  def test_part_b1
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 1)}")
    assert_equal d.part_b, 23
  end
  sig { void }
  def test_part_b2
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 2)}")
    assert_equal d.part_b, 23
  end
  sig { void }
  def test_part_b3
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 3)}")
    assert_equal d.part_b, 29
  end
  sig { void }
  def test_part_b4
    d = T.let(Days::Day06.new, Days::Day06)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.test_input_fn(6, 4)}")
    assert_equal d.part_b, 26
  end
end
