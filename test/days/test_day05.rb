# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day05"

class TestDay05 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day05.new, Days::Day05)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('05'.to_i)}")
    assert_equal d.part_a, "CMZ"
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day05.new, Days::Day05)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('05'.to_i)}")
    assert_equal d.part_b, "MCD"
  end
end
