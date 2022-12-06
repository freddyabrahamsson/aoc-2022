# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day02"

class TestDay02 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day02.new, Days::Day02)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('02'.to_i)}")
    assert_equal d.part_a, 15
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day02.new, Days::Day02)
    d.read_file("#{FN::TEST_INPUTS_DIR}/#{FN.input_fn('02'.to_i)}")
    assert_equal d.part_b, 12
  end
end
