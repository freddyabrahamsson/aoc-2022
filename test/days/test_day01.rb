# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day01"

class TestDay01 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day01.new, Days::Day01)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('01'.to_i)}")
    assert_equal d.part_a, 24_000
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day01.new, Days::Day01)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('01'.to_i)}")
    assert_equal d.part_b, 45_000
  end
end
