# typed: strict
# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/days/day04"

class TestDay04 < Minitest::Test
  extend T::Sig

  FN = Utils::FilenameUtils

  sig { void }
  def test_part_a
    d = T.let(Days::Day04.new, Days::Day04)
    d.read_file("#{FN::SPEC_INPUTS_DIR}/#{FN.input_fn('04'.to_i)}")
    assert_equal d.part_a, 2
  end

  sig { void }
  def test_part_b
    d = T.let(Days::Day04.new, Days::Day04)
    d.read_file("#{FN::SPEC_INPUTS_DIR}/#{FN.input_fn('04'.to_i)}")
    assert_equal d.part_b, 4
  end
end
